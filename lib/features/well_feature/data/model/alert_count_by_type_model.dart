
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_by_type_entity.dart';

class AlertCountByTypeModel extends AlertCountByTypeEntity {
  AlertCountByTypeModel({
    int? type,
    String? count,


  }) : super(type, count);

  factory AlertCountByTypeModel.fromJson(dynamic json) {

    return AlertCountByTypeModel(
      type: json["type"],
      count: json["count"],


    );
  }

  static List<AlertCountByTypeEntity> parseList(List<dynamic> jsonArray) {
    List<AlertCountByTypeEntity> data = [];

    for (var element in jsonArray) {
      data.add(AlertCountByTypeModel.fromJson(element));
    }

    return data;
  }


}



