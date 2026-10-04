
import 'package:mahaliii/common/params/forget_password_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/auth_repository.dart';

class ForgetPassUseCase extends UseCase<DataState<dynamic>, ForgetPasswordParams> {
  AuthRepository authRepository;

  ForgetPassUseCase(this.authRepository);

  @override
  Future<DataState> call(ForgetPasswordParams forgetPasswordParams) {
    return authRepository.forgetPass(forgetPasswordParams);
  }
}
