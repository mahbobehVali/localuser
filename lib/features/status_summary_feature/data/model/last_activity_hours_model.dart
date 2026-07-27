import 'package:mahaliii/features/status_summary_feature/domain/entity/last_activity_hours_entity.dart';


class LastActivityHoursModel extends LastActivityHoursEntity {
  LastActivityHoursModel({
    int? statusValue,
    int? typeValue,
    String? time,
    String? name,
    String? status,
    String? type,
  }) : super(statusValue, typeValue,time,name,status,type);

  factory LastActivityHoursModel.fromJson(dynamic json) {

    return LastActivityHoursModel(
      statusValue: json["statusValue"],
      typeValue: json["typeValue"],
      time: json["time"],
      name: json["name"],
      status: json["status"],
      type: json["type"],



    );
  }

  static List<LastActivityHoursEntity> parseList(List<dynamic> jsonArray) {
    List<LastActivityHoursEntity> data = [];
    for (var element in jsonArray) {
      data.add(LastActivityHoursModel.fromJson(element));
    }
    return data;
  }
}
