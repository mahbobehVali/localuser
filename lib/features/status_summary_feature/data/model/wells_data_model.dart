/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_data_entity.dart';

class WellsDataModel extends WellsDataEntity {
  WellsDataModel({
    int? level,
    int? userLocalId,
    String? pin,
    dynamic lat,
    dynamic lon,
    int? statusDevice,
    int? statusWell,
    String? wellName,
    int? areaId,
    int? deviceId,
    int? code,
    int? flowMeter,
    int? id,
    int? alert,
    int? signalLevel,
  }) : super(level,userLocalId,pin,lat,lon,statusDevice,statusWell, wellName, areaId,deviceId,code,flowMeter,id,alert,signalLevel);

  factory WellsDataModel.fromJson(dynamic json) {

    return WellsDataModel(
       level: json["level"],
       statusWell: json["status_well"],
       pin: json["pin"],
       lat: json["lat"],
       lon: json["lon"],
       statusDevice: json["status_device"],
       wellName: json["name"],
       userLocalId: json["user_local_id"],
       areaId: json["area_id"],
       deviceId: json["device_id"],
       code: json["code"],
       flowMeter: json["flowmeter"],
       id: json["id"],
       alert: json["alert"],
       signalLevel: json["signal_level"],

    );
  }
}
