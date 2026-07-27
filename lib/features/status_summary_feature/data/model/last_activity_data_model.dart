import 'package:mahaliii/features/status_summary_feature/data/model/last_activity_dates_model.dart';
import 'package:mahaliii/features/status_summary_feature/data/model/total_type_count_model.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/last_activity_data_entity.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/total_type_count_entity.dart';

import '../../domain/entity/last_activity_dates_entity.dart';


class LastActivityDataModel extends LastActivityDataEntity {
  LastActivityDataModel({
    int? id,
    String? name,
    TotalTypesCountEntity? totalTypesCount,
    List<LastActivityDatesEntity>? dates,
  }) : super(id, name, totalTypesCount,dates);

  factory LastActivityDataModel.fromJson(dynamic json) {

    return LastActivityDataModel(
      id: json["id"],
      name: json["name"],
      totalTypesCount: TotalTypesCountModel.fromJson(json["totalTypesCount"]),
      dates: LastActivityDatesModel.parseList(json["dates"]),


    );
  }
  static List<LastActivityDataEntity> parseList(List<dynamic> jsonArray) {
    List<LastActivityDataEntity> data = [];
    for (var element in jsonArray) {
      data.add(LastActivityDataModel.fromJson(element));
    }
    return data;
  }
}
