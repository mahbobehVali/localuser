import '../../../../common/params/flowmeter_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class StatusSummaryRepository {
  Future<DataState<dynamic>> wellsList();
  Future<DataState<dynamic>> lastActivities(FlowMeterParams flowMeterParams);
  // void connect(String level,int areaId);
  // void dispose();
  Future<DataState<dynamic>> summaryFlowMeter(FlowMeterParams flowMeterParams);


  // این خط حتماً باید اینجا باشد تا Bloc آن را بشناسد
  // Stream<dynamic> get dashboardStatusWater;

}
