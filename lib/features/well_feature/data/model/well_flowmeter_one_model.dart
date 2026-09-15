

import '../../domain/entity/well_flowmeter_one_entity.dart';

class WellFlowMeterOneModel extends WellFlowMeterOneEntity {
  WellFlowMeterOneModel({
    final int? id,
    final dynamic total,
    final String? xAxis,
    final num? yAxis,
    final int? deviceId,
    final int? wellId,


  }) : super(id,total,xAxis,yAxis,deviceId,wellId);

  factory WellFlowMeterOneModel.fromJson(dynamic json) {

    return WellFlowMeterOneModel(
      id: json["id"],
      total: json["total"],
      xAxis: json["xAxis"],
      yAxis: json["yAxis"],
      deviceId: json["device_id"],
      wellId: json["well_id"],

    );
  }


}



