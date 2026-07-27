
import 'package:mahaliii/features/well_feature/domain/entity/well_work_list_entity.dart';

class FlowMeterModel extends WellWorkListEntity {
  FlowMeterModel({
    String? title,
    String? type,
    // List<WellWorkListSeriesEntity>? series,
    List<dynamic>? xAxis,
    List<dynamic>? yAxis,
    dynamic totalOn,
    dynamic totalOff,

  }) : super(title, type,xAxis,yAxis,totalOn,totalOff);

  factory FlowMeterModel.fromJson(dynamic json) {

    return FlowMeterModel(
      title: json["title"],
      type: json["type"],
        xAxis: json["xAxis"],
      yAxis: json["yAxis"],
      // series:WellWorkListSeriesModel.parseList(json["series"]),
      totalOn: json["totalOn"],
      totalOff: json["totalOff"]

    );
  }


}



