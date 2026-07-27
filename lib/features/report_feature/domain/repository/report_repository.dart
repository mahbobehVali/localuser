import 'package:mahaliii/common/params/flowmeter_params.dart';

import '../../../../common/params/alert_filter_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class ReportRepository {
  Future<DataState<dynamic>> alerts(AlertFilterParams alertFilterParams);
  Future<DataState<dynamic>> getCapacity(FlowMeterParams flowMeterParams);
}
