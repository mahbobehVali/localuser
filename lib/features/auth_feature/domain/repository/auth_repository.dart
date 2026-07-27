import 'package:mahaliii/common/params/login_params.dart';

import '../../../../common/params/forget_password_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class AuthRepository {
  Future<DataState<dynamic>> login(LoginParams loginParams);
  Future<DataState<dynamic>> getCode(String mobile);
  Future<DataState<dynamic>> forgetPass(ForgetPasswordParams forgetPasswordParams);

}
