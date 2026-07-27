
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/auth_repository.dart';

class GetCodeUseCase extends UseCase<DataState<dynamic>, String> {
  AuthRepository authRepository;

  GetCodeUseCase(this.authRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(String mobile) {
    return authRepository.getCode(mobile);
  }
}
