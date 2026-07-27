
import 'package:mahaliii/features/well_feature/domain/entity/well_work_list_entity.dart';

class WellWorkListModel extends WellWorkListEntity {
  WellWorkListModel({
    String? title,
    String? type,
    List<dynamic>? xAxis,
    List<dynamic>? yAxis,
    dynamic totalOn,
    dynamic totalOff,

  }) : super(title, type,xAxis,yAxis,totalOn,totalOff);

  factory WellWorkListModel.fromJson(dynamic json) {

    return WellWorkListModel(
      title: json["title"],
      type: json["type"],
        xAxis: json["xAxis"],
      yAxis: json["yAxis"],
      totalOn: json["totalOn"],
      totalOff: json["totalOff"]

    );
  }


}



