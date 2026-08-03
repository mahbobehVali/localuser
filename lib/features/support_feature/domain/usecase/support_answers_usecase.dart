
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/support_repository.dart';

class SupportAnswersUseCase extends UseCase<DataState<dynamic>, int> {
  SupportRepository supportRepository;

  SupportAnswersUseCase(this.supportRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(id) {
    return supportRepository.getSupportAnswers(id);
  }
}
