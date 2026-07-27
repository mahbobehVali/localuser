
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/alert_repository.dart';

class DetailAlertUseCase extends UseCase<DataState<dynamic>, int> {
  AlertRepository alertRepository;

  DetailAlertUseCase(this.alertRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(id) {
    return alertRepository.detailAlert(id);
  }
}
