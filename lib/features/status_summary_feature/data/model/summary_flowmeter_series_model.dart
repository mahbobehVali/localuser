
import '../../domain/entity/summary_flowmeter_series_entity.dart';

class SummaryFlowMeterSeriesModel extends SummaryFlowMeterSeriesEntity {
  SummaryFlowMeterSeriesModel({
     String? name,
     int? id,
    List<dynamic>? xAxis,
    List<dynamic>? yAxis,

  }) : super(name,id, xAxis,yAxis);

  factory SummaryFlowMeterSeriesModel.fromJson(dynamic json) {

    return SummaryFlowMeterSeriesModel(
      name: json["name"],
      id: json["id"],
      xAxis: json["xAxis"],
      yAxis: json["yAxis"],

    );
  }

  static List<SummaryFlowMeterSeriesEntity> parseList(List<dynamic> jsonArray) {
    List<SummaryFlowMeterSeriesEntity> data = [];

    for (var element in jsonArray) {
      data.add(SummaryFlowMeterSeriesModel.fromJson(element));
    }

    return data;
  }
}



