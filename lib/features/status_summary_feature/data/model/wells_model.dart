library;

import 'package:mahaliii/features/status_summary_feature/data/model/wells_data_model.dart';

import '../../domain/entity/wells_data_entity.dart';
import '../../domain/entity/wells_entity.dart';

class WellsModel extends WellsEntity {
  const WellsModel({
    int? areaId,
    String? areaName,
    WellsDataEntity? data,
  }) : super(areaId, areaName, data);

  factory WellsModel.fromJson(dynamic json) {

    return WellsModel(
       areaId: json["area_id"],
       areaName: json["name"],
       data: WellsDataModel.fromJson(json["data"]),


    );
  }
}
