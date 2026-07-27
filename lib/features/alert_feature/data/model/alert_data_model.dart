library;

import '../../domain/entity/alert_data_entity.dart';

class AlertDataModel extends AlertDataEntity {
  AlertDataModel({

    String? wellName,
    int? id,
    int? type,
    int? status,
    String? deviceId,
    String? areaId,
    String? regionId,
    String? areaName,
    String? regionName,
    String? message,
    String? date,
    String? clock,
    String? createdAt,


  }) : super(wellName,id,type,status,deviceId, areaId, regionId,
      areaName,regionName,message,date,clock,createdAt);

  factory AlertDataModel.fromJson(dynamic json) {

    return AlertDataModel(
       wellName: json["well_name"],
       id: json["id"],
      type: json["type"],
       status: json["status"],
      deviceId: json["device_id"],
      areaId: json["area_id"],
      regionId: json["region_id"],
      areaName: json["area_name"],
      regionName: json["region_name"],
      message: json["message"],
      date: json["date"],
      clock: json["clock"],
      createdAt: json["created_at"],


    );
  }

  static List<AlertDataEntity> parseList(List<dynamic> jsonArray) {
    List<AlertDataEntity> data = [];
    for (var element in jsonArray) {
      data.add(AlertDataModel.fromJson(element));
    }
    return data;
  }
}
