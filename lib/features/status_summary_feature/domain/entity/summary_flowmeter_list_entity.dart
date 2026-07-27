import 'package:mahaliii/features/status_summary_feature/domain/entity/summary_flowmeter_series_entity.dart';

class SummaryFlowMeterListEntity {
    final String? title;
    final String? type;
   final  List<SummaryFlowMeterSeriesEntity>? series;


 SummaryFlowMeterListEntity( this.title,this.type,this.series);
}
