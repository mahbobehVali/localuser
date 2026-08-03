
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/support_repository.dart';

class SupportCloseUseCase extends UseCase<DataState<dynamic>, int> {
  SupportRepository supportRepository;

  SupportCloseUseCase(this.supportRepository);

  @override
  Future<DataState> call(int id) {
    return supportRepository.supportClose(id);
  }
}
