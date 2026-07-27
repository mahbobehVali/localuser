
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/account_repository.dart';

class ChangeAlertUseCase extends UseCase<DataState<dynamic>, int> {
  PanelRepository panelRepository;

  ChangeAlertUseCase(this.panelRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(type) {
    return panelRepository.changeAlert(type);
  }
}
