

import '../../domain/entity/well_flowmeter_list_entity.dart';
import '../../domain/entity/well_flowmeter_one_entity.dart';

class WellFlowMeterOneModel extends WellFlowMeterOneEntity {
  WellFlowMeterOneModel({
    final int? id,
    final dynamic total,
    final String? xAxis,
    final num? yAxis,


  }) : super(id,total,xAxis,yAxis);

  factory WellFlowMeterOneModel.fromJson(dynamic json) {

    return WellFlowMeterOneModel(
      id: json["id"],
      total: json["total"],
      xAxis: json["xAxis"],
      yAxis: json["yAxis"],

    );
  }


}



