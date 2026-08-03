import 'package:mahaliii/common/params/flowmeter_params.dart';

import '../../../../common/params/send_new_request_to_support_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class SupportRepository {
  Future<DataState<dynamic>> getSupportMessage(FlowMeterParams flowMeterParams);
  Future<DataState<dynamic>> getSupportAnswers(int id);
  Future<DataState<dynamic>> sendSupport(SendNewSupportParams sendNewSupportParams);
  Future<DataState<dynamic>> sendAnswer(SendNewSupportParams sendNewSupportParams);
  Future<DataState<dynamic>> supportClose(int id);
}
