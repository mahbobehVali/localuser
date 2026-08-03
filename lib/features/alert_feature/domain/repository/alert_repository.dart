import 'package:mahaliii/common/params/alert_filter_params.dart';

import '../../../../common/params/send_new_request_to_support_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class AlertRepository {
  Future<DataState<dynamic>> alerts(AlertFilterParams alertFilterParams);
  Future<DataState<dynamic>> detailAlert(int id);
  Future<DataState<dynamic>> alertCreate(SendNewSupportParams sendNewSupportParams);
}
