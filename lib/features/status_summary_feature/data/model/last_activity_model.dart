import 'package:mahaliii/features/status_summary_feature/data/model/last_activity_data_model.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/last_activity_data_entity.dart';

import '../../domain/entity/last_activity_entity.dart';


class LastActivityModel extends LastActivityEntity {
  LastActivityModel({
    int? total,
    int? page,
    int? limit,
    int? lastPage,
    List<LastActivityDataEntity>? data,
  }) : super(total, page, limit,lastPage,data);

  factory LastActivityModel.fromJson(dynamic json) {

    return LastActivityModel(
      total: json["total"],
      page: json["page"],
      limit: json["limit"],
      lastPage: json["last_page"],
      data:   LastActivityDataModel.parseList(json["data"]),


    );
  }
}
