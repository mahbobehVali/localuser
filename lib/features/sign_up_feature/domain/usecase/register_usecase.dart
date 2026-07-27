

import '../../../../common/params/sign_up_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/sign_up_repository.dart';

class RegisterUseCase extends UseCase<DataState<dynamic>,SignUpParams>{
  SignUpRepository authRepository;

  RegisterUseCase(this.authRepository);

  @override
  Future<DataState> call(SignUpParams signUpParams) {
    return authRepository.register(signUpParams);
  }
}