
import '../../../../common/params/login_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/auth_repository.dart';

class LoginUseCase extends UseCase<DataState<dynamic>, LoginParams> {
  AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(loginParams) {
    return authRepository.login(loginParams);
  }
}
