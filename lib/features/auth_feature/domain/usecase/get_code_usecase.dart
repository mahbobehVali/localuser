
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/auth_repository.dart';

class GetCodeUseCase extends UseCase<DataState<dynamic>, String> {

  AuthRepository authRepository;

  GetCodeUseCase(this.authRepository);

  @override
  Future<DataState> call(String mobile) {
    print("use");
    return authRepository.getCode(mobile);
  }
}
