

import 'package:mahaliii/common/params/sign_up_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/sign_up_repository.dart';

class SendValidationCodeUseCase extends UseCase<DataState<dynamic>,SignUpParams>{
  SignUpRepository authRepository;

  SendValidationCodeUseCase(this.authRepository);

  @override
  Future<DataState<dynamic>> call(SignUpParams validationParams) {
    return authRepository.getValidationCode(validationParams);
  }
}