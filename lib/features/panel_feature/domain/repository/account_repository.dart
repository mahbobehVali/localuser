import '../../../../common/params/change_password_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class PanelRepository {
  Future<DataState<dynamic>> changePassword(ChangePasswordParams changePasswordParams);
  Future<DataState<dynamic>> sendSms();
  Future<DataState<dynamic>> changeAlert(int type);

}
