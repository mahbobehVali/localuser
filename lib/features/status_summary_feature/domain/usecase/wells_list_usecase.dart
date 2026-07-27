
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/status_summary_repository.dart';

class WellsListUseCase extends UseCase<DataState<dynamic>, NoParams> {
  StatusSummaryRepository statusSummaryRepository;

  WellsListUseCase(this.statusSummaryRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(noParams) {
    return statusSummaryRepository.wellsList();
  }
}
