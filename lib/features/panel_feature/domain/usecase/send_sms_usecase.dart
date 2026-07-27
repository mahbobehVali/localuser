
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/account_repository.dart';

class SendSmsUseCase extends UseCase<DataState<dynamic>, NoParams> {
  PanelRepository panelRepository;

  SendSmsUseCase(this.panelRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(noParams) {
    return panelRepository.sendSms();
  }
}
