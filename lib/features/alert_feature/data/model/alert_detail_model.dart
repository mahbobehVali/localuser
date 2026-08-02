library;

import '../../domain/entity/alert_data_entity.dart';
import '../../domain/entity/alert_detail_entity.dart';

class AlertDetailModel extends AlertDetailEntity {
  AlertDetailModel({

    int? id,
    String? alertId,
    String? userId,
    int? status,

    String? message,

    String? date,
    String? clock,
    String? createdAt,
    String? userName,


  }) : super(id,alertId,userId,status,message,date,clock,createdAt,userName);

  factory AlertDetailModel.fromJson(dynamic json) {

    return AlertDetailModel(
       id: json["id"],
      alertId: json["alert_id"],
      userId: json["user_id"],
       status: json["status"],
      message: json["message"],
      date: json["date"],
      clock: json["clock"],
      createdAt: json["created_at"],
      userName: json["user_name"],


    );
  }

  static List<AlertDetailEntity> parseList(List<dynamic> jsonArray) {
    List<AlertDetailEntity> data = [];
    for (var element in jsonArray) {
      data.add(AlertDetailModel.fromJson(element));
    }
    return data;
  }
}
