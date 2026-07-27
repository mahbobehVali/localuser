
import 'package:mahaliii/features/status_summary_feature/data/model/summary_flowmeter_series_model.dart';

import '../../domain/entity/summary_flowmeter_list_entity.dart';
import '../../domain/entity/summary_flowmeter_series_entity.dart';

class SummaryFlowMeterListModel extends SummaryFlowMeterListEntity {
  SummaryFlowMeterListModel({
    String? title,
    String? type,
    List<SummaryFlowMeterSeriesEntity>? series,


  }) : super(title,type,series);

  factory SummaryFlowMeterListModel.fromJson(dynamic json) {

    return SummaryFlowMeterListModel(
      title: json["title"],
      type: json["type"],
      series:SummaryFlowMeterSeriesModel.parseList(json["series"]),


    );
  }


}



