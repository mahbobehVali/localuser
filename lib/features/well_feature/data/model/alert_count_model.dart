
import 'package:mahaliii/features/well_feature/data/model/alert_count_by_date_model.dart';
import 'package:mahaliii/features/well_feature/data/model/alert_count_by_type_model.dart';
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_by_date_entity.dart';
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_by_type_entity.dart';
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_entity.dart';

class AlertCountModel extends AlertCountEntity {
  AlertCountModel({
     List<AlertCountByDateEntity>? alertCountByDate,
     int? totalCount,
     List<AlertCountByTypeEntity>? countByType,



  }) : super(alertCountByDate,totalCount,countByType);

  factory AlertCountModel.fromJson(dynamic json) {

    return AlertCountModel(
      alertCountByDate: AlertCountByDateModel.parseList(json["countByDate"].isEmpty?[]:json["countByDate"]),
      totalCount: json["totalCount"],
      countByType: AlertCountByTypeModel.parseList(
        json["countByType"] ?? [],
      ),

    );
  }


}



