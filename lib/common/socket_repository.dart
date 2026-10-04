import 'dart:async';

import 'package:mahaliii/common/params/create_time_params.dart';
import 'package:mahaliii/common/utils/sharedpreference.dart';
import 'package:mahaliii/features/well_feature/data/model/on_off_model.dart';
import 'package:mahaliii/features/well_feature/data/model/signal_level_model.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;

import '../features/status_summary_feature/data/model/water_model.dart';
import '../locator.dart';

enum FingerprintSource {
  requestResponse, // لیسنر اول
  statusListener,  // لیسنر دوم
}

class FingerprintResponse {
  final dynamic status;
  final int? userLocalID;
  final FingerprintSource source;

  FingerprintResponse({required this.status, this.userLocalID, required this.source});
}

class SocketRepository {
  i_o.Socket? _socket;
  bool isConnecting = false;
  String? _managerPin;
  String? _currentWellPin;

  // استریم کنترلرها
  StreamController<dynamic> _statusControllerCheckFinger = StreamController<dynamic>.broadcast();
  StreamController<WaterModel> _waterController = StreamController<WaterModel>.broadcast();
  StreamController<dynamic> _createTimeController = StreamController<dynamic>.broadcast();
  StreamController<dynamic> _deleteTimeController = StreamController<dynamic>.broadcast();
  StreamController<dynamic> _onAndOffTimeController = StreamController<dynamic>.broadcast();
  StreamController<dynamic> _todayController = StreamController<dynamic>.broadcast();
  StreamController<SignalLevelModel> _signalController = StreamController<SignalLevelModel>.broadcast();

  // Getterهای اصلاح‌شده
  Stream<dynamic> get dashboardStatusCheckFinger => _statusControllerCheckFinger.stream;
  Stream<WaterModel> get waterStream => _waterController.stream;
  Stream<dynamic> get createTimeStream => _createTimeController.stream;
  Stream<dynamic> get deleteTimeStream => _deleteTimeController.stream;
  Stream<dynamic> get onAndOffTimeStream => _onAndOffTimeController.stream;
  Stream<dynamic> get todayStream => _todayController.stream;

  // 🟢 اصلاح شد: اتصال درست به _signalController
  Stream<SignalLevelModel> get signalStream => _signalController.stream;

  Completer<bool>? _connectCompleter;

  // دریافت توکن
  Future<String> _getOrWaitForToken({int maxRetries = 10, Duration delay = const Duration(milliseconds: 500)}) async {
    for (int i = 0; i < maxRetries; i++) {
      final token = await locator<SharedPrefOperator>().getUserToken();
      if (token.trim().isNotEmpty) {
        print("🔑 Token successfully fetched on attempt ${i + 1}: $token");
        return token;
      }
      print("⏳ Token is empty. Retrying (${i + 1}/$maxRetries)...");
      await Future.delayed(delay);
    }
    return "";
  }

  Future<bool> initAndConnect(String managerPin, [String? level, int? id]) async {
    // بازسازی استریم‌ها در صورت بسته بودن
    if (_waterController.isClosed) _waterController = StreamController<WaterModel>.broadcast();
    if (_createTimeController.isClosed) _createTimeController = StreamController<dynamic>.broadcast();
    if (_deleteTimeController.isClosed) _deleteTimeController = StreamController<dynamic>.broadcast();
    if (_onAndOffTimeController.isClosed) _onAndOffTimeController = StreamController<dynamic>.broadcast();
    if (_statusControllerCheckFinger.isClosed) _statusControllerCheckFinger = StreamController<dynamic>.broadcast();
    if (_signalController.isClosed) _signalController = StreamController<SignalLevelModel>.broadcast();

    _managerPin = managerPin;

    // اگر متصل است، روم‌ها را جوین شو و خروج کن
    if (_socket != null && _socket!.connected) {
      print("Socket already connected.");
      _joinRooms();
      return true;
    }

    // اگر در حال اتصال است، منتظر همان Completer قبلی بمان
    if (isConnecting && _connectCompleter != null) {
      return _connectCompleter!.future;
    }

    isConnecting = true;
    _connectCompleter = Completer<bool>();

    // دریافت توکن جدید
    String token = await _getOrWaitForToken(maxRetries: 10, delay: const Duration(milliseconds: 500));

    if (token.trim().isEmpty) {
      print("❌ Could not obtain a valid token. Aborting connection.");
      isConnecting = false;
      if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
        _connectCompleter!.complete(false);
      }
      return false;
    }

    // تمیزکاری سوکت مرده قبل از ساخت سوکت جدید
    if (_socket != null) {
      _socket!.clearListeners();
      _socket!.dispose();
      _socket = null;
    }

    print("token.isNotEmpty: $token");

    // ساخت نمونه جدید سوکت با ساختار صحیح
    _socket = i_o.io(
      'https://user.abyarinovin.ir',
      i_o.OptionBuilder()
          .setTransports(['websocket']) // اجبار استفاده از WebSocket
          .setAuth({'token': token})
          .enableAutoConnect() // متصل شدن خودکار
          .enableReconnection()
          .enableForceNew()
          .build(),
    );

    _socket!.on('unauthorized', (data) => print('❌ Unauthorized: $data'));
    _socket!.on('error', (data) => print('❌ Socket General Error: $data'));
    _socket!.on('connect_timeout', (data) => print('⏰ Connect Timeout: $data'));

    _socket!.onConnectError((data) {
      print('Connect Error: $data');
      if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
        _connectCompleter!.complete(false);
      }
      isConnecting = false;
    });

    _socket!.onError((data) => print('Socket Error: $data'));
    _socket!.onDisconnect((data) {
      print('Socket Disconnected: $data');
      isConnecting = false;
    });

    setupGlobalListeners();

    _socket!.onConnect((_) async {
      print('Socket Connected globally!');
      try {
        _joinRooms();
        if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
          _connectCompleter!.complete(true);
        }
      } catch (e) {
        print("Error inside onConnect: $e");
      } finally {
        isConnecting = false;
      }
    });

    print('Connecting socket...');
    // در صورتی که enableAutoConnect فعال باشد نیاز به فراخوانی مجدد connect نیست اما فراخوانی آن مشکلی ایجاد نمی‌کند:
    _socket!.connect();

    return _connectCompleter!.future.timeout(
      const Duration(seconds: 16),
      onTimeout: () {
        isConnecting = false;
        if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
          _connectCompleter!.complete(false);
        }
        return false;
      },
    );
  }
  // 🟢 متد اختصاصی برای جوین شدن به روم‌ها
  void _joinRooms() {
    if (_socket == null || !_socket!.connected) return;

    if (_managerPin != null) {
      print("joinroom manager: $_managerPin");
      _socket!.emit("join/room", {'room': _managerPin});
    }
    if (_currentWellPin != null) {
      print("joinroom well: $_currentWellPin");
      _socket!.emit("join/room", {'room': _currentWellPin});
    }
  }

  /// متد ورود به صفحه یک چاه جدید
  Future<bool> joinWellRoom(String wellPin) async {
    print("joinWellRoomCalled");
    if (_currentWellPin == wellPin) return true;

    print("Switching well room from $_currentWellPin to: $wellPin");
    _currentWellPin = wellPin;

    if (_socket != null && _socket!.connected) {
      print("Socket is connected, emitting room: $wellPin");
      _socket!.emit("join/room", {'room': wellPin});
      return true;
    } else {
      print("Socket not connected yet. Initializing connection...");
      initAndConnect(_managerPin ?? "manger");
      return false;
    }
  }

  /// گوش دادن دائمی به رویدادها
  void setupGlobalListeners() {
    if (_socket == null) return;

    _socket!.off("dashboard/total/water");
    _socket!.off("program/add");
    _socket!.off("program/delete");
    _socket!.off("motor/status");
    _socket!.off("fingerprint/request_response");
    _socket!.off("fingerprint/status");
    _socket!.off("signal_quality");

    _socket!.on("dashboard/total/water", (data) {
      if (data != null && !_waterController.isClosed) {
        try {
          _waterController.add(WaterModel.fromJson(data));
          print('Data Water successfully added to stream');
        } catch (e) {
          print('JSON Water Parsing Error: $e');
        }
      }
    });

    _socket!.on("signal_quality", (data) {
      if (data != null && !_signalController.isClosed) {
        print("datasignal: $data");
        try {
          final model = SignalLevelModel.fromJson(data);
          _signalController.add(model);
          print('Signal level added to stream successfully');
        } catch (e) {
          print('JSON Signal Parsing Error: $e');
        }
      }
    });

    _socket!.on("program/add", (data) {
      if (data != null && !_createTimeController.isClosed) {
        try {
          _createTimeController.add(data["status"]);
          print('program/add successfully added to stream');
        } catch (e) {
          print('JSON Program Add Error: $e');
        }
      }
    });

    _socket!.on("program/delete", (data) {
      if (data != null && !_deleteTimeController.isClosed) {
        try {
          _deleteTimeController.add(data["status"]);
          print('program/delete successfully added to stream');
        } catch (e) {
          print('JSON Program Delete Error: $e');
        }
      }
    });

    _socket!.on("motor/status", (data) {
      print("motor status data: $data");
      if (data != null && !_onAndOffTimeController.isClosed) {
        try {
          final model = OnOffModel.fromJson(data);
          _onAndOffTimeController.add(model);
          print('motor/status successfully added to stream');
        } catch (e) {
          print('JSON Motor Status Error: $e');
        }
      }
    });

    // لیسنر اختصاصی اثر انگشت
    _socket!.on("fingerprint/status", (statusData) {
      print(" [Socket] fingerprint/status Triggered! Data: $statusData");
      if (statusData != null && !_statusControllerCheckFinger.isClosed) {
        try {
          _statusControllerCheckFinger.add(
            FingerprintResponse(
              status: statusData["status"],
              userLocalID: statusData["userLocalID"],
              source: FingerprintSource.statusListener,
            ),
          );
        } catch (e) {
          print('JSON Fingerprint Status Error: $e');
        }
      }
    });

    _socket!.on("fingerprint/request_response", (data) {
      print('fingerprint/request_response listener...');
      if (data == null || _statusControllerCheckFinger.isClosed) return;

      try {
        var status = data["status"];
        _statusControllerCheckFinger.add(
          FingerprintResponse(
            status: status,
            source: FingerprintSource.requestResponse,
          ),
        );
      } catch (e) {
        print('JSON Fingerprint Response Error: $e');
      }
    });
  }

  Future<void> safeEmit(String event, Map<String, dynamic> data) async {
    String pin = data["pin"] ?? _managerPin ?? "manger";

    if (_socket == null || !_socket!.connected) {
      print("Socket not ready for $event. Triggering background connect...");
      initAndConnect(pin);
      return;
    }

    if (_socket != null && _socket!.connected) {
      print("datapin${data["pin"]}");
      print("🚀 Emitting $event to server...");
      _socket!.emit(event, data);
    } else {
      print("Failed to emit $event, socket still disconnected.");
    }
  }

  void requestWaterData(dynamic level, dynamic areaId) {
    safeEmit("dashboard/data/request", {"level": level, "id": areaId, "pin": "manger"});
  }

  void requestCreateTimeData(CreateTimeParams params) {
    safeEmit("program/add", {
      "pin": params.pin,
      "code": params.code,
      "userLocalID": params.userLocalID,
      "deviceID": params.deviceID,
      "weekDay": params.weekDay,
      "startTime": params.startTime,
      "endTime": params.endTime,
    });
  }

  Future<void> requestFinger(dynamic deviceId, String pin) async {
    if (_socket == null) {
      await initAndConnect(pin);
    }
    await safeEmit("fingerprint/add_request", {"deviceID": deviceId, "pin": pin});
  }

  Future<void> requestDeleteTimeData(CreateTimeParams params) async {
    safeEmit("program/delete", {
      "pin": params.pin,
      "code": params.code,
      "userLocalID": params.userLocalID,
      "deviceID": params.deviceID,
      "weekDay": params.day,
      "startTime": params.startTime.toString().toEnglishDigit(),
      "endTime": params.endTime.toString().toEnglishDigit(),
    });
  }

  void onAndOff(CreateTimeParams params) {
    safeEmit("motor/change/status", {
      "pin": params.pin,
      "code": params.code,
      "userLocalID": params.userLocalID,
      "deviceID": params.deviceID,
      "status": params.status,
    });
  }

  void dispose() {
    print("dispose socket repository");
    _socket?.off("dashboard/total/water");
    _socket?.off("program/add");
    _socket?.off("program/delete");
    _socket?.off("motor/status");
    _socket?.off("fingerprint/request_response");
    _socket?.off("fingerprint/status");
    _socket?.off("signal_quality");

    if (!_waterController.isClosed) _waterController.close();
    if (!_createTimeController.isClosed) _createTimeController.close();
    if (!_deleteTimeController.isClosed) _deleteTimeController.close();
    if (!_onAndOffTimeController.isClosed) _onAndOffTimeController.close();
    if (!_statusControllerCheckFinger.isClosed) _statusControllerCheckFinger.close();
    if (!_todayController.isClosed) _todayController.close();
    if (!_signalController.isClosed) _signalController.close();

    print("✅ All Socket Resources Disposed Safely.");
  }

  Future<void> logout() async {
    print("🔄 Socket Logout: Disconnecting and cleaning up...");

    if (_socket != null) {
      try {
        _socket!.emit("leave/room", {'room': _managerPin ?? "manger"});
        if (_currentWellPin != null) {
          _socket!.emit("leave/room", {'room': _currentWellPin});
        }
      } catch (_) {}

      _socket!.clearListeners();
      _socket!.disconnect();

      // 🔑 پاک کردن هدرها و گزینه‌های اتصال قدیمی
      // _socket!.io.options?['extraHeaders'] = {};
      _socket!.auth = null;

      // _socket!.destroy(); // 👈 استفاده از destroy به همراه dispose
      _socket!.dispose();
      _socket = null;
    }

    isConnecting = false;
    _managerPin = null;
    _currentWellPin = null;
    _connectCompleter = null;

    print("✅ Socket successfully logged out & cleared.");
  }

}