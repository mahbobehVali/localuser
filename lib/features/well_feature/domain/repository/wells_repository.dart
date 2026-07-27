
import '../../../../common/params/flowmeter_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class WellsRepository {

  Future<DataState<dynamic>> wellWorkHour(FlowMeterParams flowMeterParams);
  Future<DataState<dynamic>> alertCount(FlowMeterParams flowMeterParams);
  Future<DataState<dynamic>> flowMeter(FlowMeterParams flowMeterParams, {bool ignoreAllWell = false});
  Future<DataState<dynamic>> getProgramList(int id);



}
