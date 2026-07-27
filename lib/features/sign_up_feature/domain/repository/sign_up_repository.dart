import '../../../../common/params/sign_up_params.dart';
import '../../../../common/utils/data_state.dart';

abstract class SignUpRepository {

  // Future<DataState<dynamic>> passwordForgetButton(mobile);

  // Future<DataState<dynamic>> newPasswordConfirmationButton(newPasswordParams);

  Future<DataState<dynamic>> firstSignUp(SignUpParams firstLevelSignInParams);
  // Future<DataState<dynamic>> userFirstSignUp(firstLevelSignInParams);
  // Future<DataState<dynamic>> codeValidation(validationParams);
  // Future<DataState<dynamic>> againSendValidationCode(mobile);
  Future<DataState<dynamic>> register(SignUpParams signUpParams);
  Future<DataState<dynamic>> getRegions();
  Future<DataState<dynamic>> getArea(int id);


}
