import 'package:mahaliii/features/status_summary_feature/data/model/last_activity_hours_model.dart';

import '../../domain/entity/last_activity_dates_entity.dart';
import '../../domain/entity/last_activity_hours_entity.dart';


class LastActivityDatesModel extends LastActivityDatesEntity {
  LastActivityDatesModel({
    String? date,
    List<LastActivityHoursEntity>? hours,
  }) : super(date, hours);

  factory LastActivityDatesModel.fromJson(dynamic json) {

    return LastActivityDatesModel(
      date: json["date"],
      hours:LastActivityHoursModel.parseList( json["hours"]),



    );
  }
  static List<LastActivityDatesEntity> parseList(List<dynamic> jsonArray) {
    List<LastActivityDatesEntity> data = [];
    for (var element in jsonArray) {
      data.add(LastActivityDatesModel.fromJson(element));
    }
    return data;
  }
}
