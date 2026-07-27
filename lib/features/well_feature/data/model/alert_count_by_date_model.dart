
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_by_date_entity.dart';

class AlertCountByDateModel extends AlertCountByDateEntity {
  AlertCountByDateModel({
    String? period,
    String? count,


  }) : super(period, count);

  factory AlertCountByDateModel.fromJson(dynamic json) {

    return AlertCountByDateModel(
      period: json["period"],
      count: json["count"],


    );
  }

  static List<AlertCountByDateEntity> parseList(List<dynamic> jsonArray) {
    List<AlertCountByDateEntity> data = [];

    for (var element in jsonArray) {
      data.add(AlertCountByDateModel.fromJson(element));
    }

    return data;
  }


}



