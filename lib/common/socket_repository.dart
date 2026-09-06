import 'dart:async';

import 'package:mahaliii/common/params/create_time_params.dart';
import 'package:mahaliii/common/utils/sharedpreference.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:socket_io_client/socket_io_client.dart' as i_o;

import '../features/status_summary_feature/data/model/water_model.dart';
import '../features/well_feature/data/model/well_flowmeter_one_model.dart';
import '../locator.dart';

Future<dynamic> getToken() async {
  final userToken = locator<SharedPrefOperator>().getUserToken();
  return userToken;
}

enum FingerprintSource {
  requestResponse, // لیسنر اول
  statusListener,  // لیسنر دوم
}

class FingerprintResponse {
  final dynamic status;
  final int? userLocalID;
  final FingerprintSource source;

  FingerprintResponse({required this.status,this.userLocalID, required this.source});
}

class SocketRepository {
  i_o.Socket? _socket;
  bool isConnecting = false; // جلوگیری از درخواست‌های همزمان اتصال

  // استریم کنترلرها برای صفحات مختلف
  final _statusControllerCheckFinger = StreamController<dynamic>.broadcast();
  final _waterController = StreamController<dynamic>.broadcast();
  final _createTimeController = StreamController<dynamic>.broadcast();
  final _deleteTimeController = StreamController<dynamic>.broadcast();
  final _onAndOffTimeController = StreamController<dynamic>.broadcast();
  final _todayController = StreamController<dynamic>.broadcast();

  // گرفتن استریم‌ها در صفحات/بلاک‌ها
  Stream<dynamic> get dashboardStatusCheckFinger => _statusControllerCheckFinger.stream;
  Stream<dynamic> get waterStream => _waterController.stream;
  Stream<dynamic> get createTimeStream => _createTimeController.stream;
  Stream<dynamic> get deleteTimeStream => _deleteTimeController.stream;
  Stream<dynamic> get onAndOffTimeStream => _onAndOffTimeController.stream;
  Stream<dynamic> get todayStream => _todayController.stream;

  /// ۱. این متد را فقط یک‌بار در ابتدای برنامه یا ورود کاربر صدا می‌زنید
  Future<void> initAndConnect(String pin) async {
    print("initAndConnectCalled---pin:$pin");

// اگر سوکت ساخته شده و وصل است، فقط اتاق را عوض کن یا خارج شو
    if (_socket != null && _socket!.connected) {
      print("Socket already connected. Joining room: $pin");
      _socket!.emit("join/room", {'room': pin});
      return;
    }
    if (isConnecting) return; // اگر در حال اتصال است، منتظر بمان
    isConnecting = true;

    String token = await getToken();
    print(token);

    _socket = i_o.io('https://www.abyarinovin.ir',
        i_o.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({'token': token})
            .setAuth({'token': token})
            .enableAutoConnect()
            .build()
    );

    setupGlobalListeners();
    _socket!.onConnect((_) async {
      print(' Socket Connected globally!');
      // یک‌بار برای همیشه وارد اتاق می‌شویم
      _socket!.emit("join/room", {'room': pin});

      isConnecting = false;
      print(isConnecting);
    });

    _socket!.onDisconnect((data) {
      print('Socket Disconnected');
      isConnecting = false;
    });
    _socket!.onConnectError((data) => print(' Connect Error: $data'));
    _socket!.connect();
  }

  /// ۲. گوش دادن دائمی به رویدادها (گوش‌ها همیشه باز هستند، اما تا درخواستی فرستاده نشود، دیتایی نمی‌آید)
  void setupGlobalListeners() {
    if (_socket == null) return;
    _socket!.off("dashboard/total/water");
    _socket!.off("program/add");
    _socket!.off("program/delete");
    _socket!.off("motor/status");
    _socket?.off("fingerprint/request_response");

    _socket!.on("dashboard/total/water", (data) {
      print("dashboard/total/water");

      if (data != null && !_waterController.isClosed) {
        // تبدیل به مدل و اضافه کردن به استریم آب
        try {
          _waterController.add(WaterModel.fromJson(data));
          print(' Data Water successfully added to stream');
        } catch (e) {
          print('JSON 1 Parsing Error: $e');
        }      }
    });

    _socket!.on("flowmeter/today", (data) {
      // print("todayyyyyyyyyy");
      if (data != null && !_todayController.isClosed) {
        // تبدیل به مدل و اضافه کردن به استریم آب
        try {
          final model=WellFlowMeterOneModel.fromJson(data);

          _todayController.add(model);

          // print(' flowmeter Today successfully added to stream');
        } catch (e) {

          print('JSON 2 Parsing Error: $e');
        }      }
    });


    _socket!.on("program/add", (data) {
      if (data != null && !_createTimeController.isClosed) {
        // تبدیل به مدل و اضافه کردن به استریم آب
        try {
          _createTimeController.add(data["status"]);
          print(' program/add successfully added to stream');

        } catch (e) {
          print('JSON Parsing Error: $e');
        }
      }
    });

    _socket!.on("program/delete", (data) {
      if (data != null && !_deleteTimeController.isClosed) {
        // تبدیل به مدل و اضافه کردن به استریم آب
        try {
          _deleteTimeController.add(data["status"]);

          print(' program/delete successfully added to stream');
        } catch (e) {
          print('JSON Parsing Error: $e');
        }      }
    });

    _socket!.on("motor/status", (data) {
      print("pomplisten");
      if (data != null && !_onAndOffTimeController.isClosed) {
        // تبدیل به مدل و اضافه کردن به استریم آب
        try {
          _onAndOffTimeController.add(data["status"]);

          print(' motor/status successfully added to stream');
        } catch (e) {
          print(' JSON Parsing Error: $e');
        }      }
    });

    // ۱. تعریف لیسنر دوم به صورت یک تابع مستقل
    void onFingerprintStatus(dynamic statusData) {
      print("📈 [Socket] fingerprint/status Triggered! Data: $statusData");
      if (statusData == null) return;

      if (!_statusControllerCheckFinger.isClosed) {
        try {
          final status = statusData["status"];
          final userLocalID = statusData["userLocalID"];
          _statusControllerCheckFinger.add(
            FingerprintResponse(
              status: status,
              userLocalID: userLocalID,
              source: FingerprintSource.statusListener,
            ),
          );
          print(' Status updated in stream: $status');
        } catch (e) {
          print('❌ JSON Parsing Error in Status: $e');
        }
      }
    }

    _socket!.on("fingerprint/request_response", (data) {

      if (data == null || _statusControllerCheckFinger.isClosed) return;

        try {
          print(' Activating fingerprint/request_response listener...');

          var status = data["status"];

          if (status == 1 || status == "1") {
            _statusControllerCheckFinger.add(
              FingerprintResponse(
                status: status,
                source: FingerprintSource.requestResponse,
              ),
            );

            print(' Activating fingerprint/status listener...');

            _socket!.on("fingerprint/status", onFingerprintStatus);


          } else {
            // 💡 فرستادن حالت‌های غیر از ۱ مربوط به لیسنر اول
            _statusControllerCheckFinger.add(
              FingerprintResponse(
                status: status,
                source: FingerprintSource.requestResponse,
              ),
            );
            print(' Activating fingerprint/status listener...');
          }
          // بخش else اضافی حذف شد چون بالا به استریم add شده است.

        } catch (e) {
          print(' JSON Parsing Error in Response: $e');
        }
      });
  }

  // تعریف یکCompleter برای جلوگیری از تلاش‌های هم‌زمان جهت اتصال
  Completer<void>? _connectingCompleter;

  Future<void> safeEmit(String event, Map<String, dynamic> data) async {
    print("pin:${data["pin"]}");
    // اگر سوکت وصل نیست
    if (_socket == null || !_socket!.connected) {

      // اگر در حال حاضر متدی مشغول وصل کردن سوکت است، منتظر همان بماند
      if (_connectingCompleter != null && !_connectingCompleter!.isCompleted) {
        await _connectingCompleter!.future;
      } else {
        _connectingCompleter = Completer<void>();
        await initAndConnect(data["pin"]);

        int attempts = 0;
        while ((_socket == null || !_socket!.connected) && attempts < 40) {
          print("attempts");
          await Future.delayed(const Duration(milliseconds: 100));
          attempts++;
        }
        _connectingCompleter!.complete();
      }
    }

    // ارسال داده در صورت اتصال
    if (_socket != null && _socket!.connected) {
      print("🚀 Emitting $event to server...");
      _socket!.emit(event, data);
    } else {
      print(" Cannot emit $event. Socket is disconnected.");
    }
  }

  void requestWaterData(dynamic level, dynamic areaId) {
    print(' dashboard/data Request');
    safeEmit("dashboard/data/request", {"level": level, "id": areaId,"pin": "manger"});
  }

  void requestCreateTimeData(CreateTimeParams params) {
    print(' program/add Request');

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
    print(' fingerprint/add_request Request');

    // اگر سوکت کلاً ساخته نشده، اول وصلش کن
    if (_socket == null) {
      print("_socketnull");
      await initAndConnect(pin);
    }
    print("nonull");

    // _socket?.off("fingerprint/request_response");
    await safeEmit("fingerprint/add_request", {"deviceID": deviceId , "pin": pin});
  }

  Future<void> requestDeleteTimeData(CreateTimeParams params) async {

    print(' program/delete Request');
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
    print(' motor/change/status Request');

    safeEmit("motor/change/status", {
      "pin": params.pin,
      "code": params.code,
      "userLocalID": params.userLocalID,
      "deviceID": params.deviceID,
      "status": params.status,
    });
  }

  void dispose() {
    print("dispose");
    _socket?.off("dashboard/total/water");
    _socket?.off("program/add");
    _socket?.off("program/delete");
    _socket?.off("motor/status");
    _socket?.off("fingerprint/request_response");
    _socket?.off("fingerprint/status");
    _socket?.disconnect();
    _socket?.dispose();

    if (!_waterController.isClosed) _waterController.close();
    if (!_createTimeController.isClosed) _createTimeController.close();
    if (!_deleteTimeController.isClosed) _deleteTimeController.close();
    if (!_onAndOffTimeController.isClosed) _onAndOffTimeController.close();
    if (!_statusControllerCheckFinger.isClosed) _statusControllerCheckFinger.close();

    print("✅ All Socket Resources Disposed Safely.");
  }
}