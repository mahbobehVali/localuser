

import '../../domain/entity/well_flowmeter_list_entity.dart';

class WellFlowMeterListModel extends WellFlowMeterListEntity {
  WellFlowMeterListModel({
    final String? title,
    final String? type,
    final dynamic total,
    final List<dynamic>? xAxis,
    final List<dynamic>? yAxis,


  }) : super(title, type,total,xAxis,yAxis);

  factory WellFlowMeterListModel.fromJson(dynamic json) {

    return WellFlowMeterListModel(
      title: json["title"],
      type: json["type"],
      total: json["total"],
      xAxis: json["xAxis"],
      yAxis: json["yAxis"],

    );
  }


}



