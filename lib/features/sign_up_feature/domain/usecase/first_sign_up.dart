

import '../../../../common/params/sign_up_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/sign_up_repository.dart';

class FirstSignupUseCase extends UseCase<DataState<dynamic>,SignUpParams>{
  SignUpRepository authRepository;

  FirstSignupUseCase(this.authRepository);

  @override
  Future<DataState> call(signUpParams) {
    return authRepository.firstSignUp(signUpParams);
  }
}