
import 'package:mahaliii/common/params/change_password_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/account_repository.dart';

class ChangePasswordUseCase extends UseCase<DataState<dynamic>, ChangePasswordParams> {
  PanelRepository panelRepository;

  ChangePasswordUseCase(this.panelRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(changePasswordParams) {
    return panelRepository.changePassword(changePasswordParams);
  }
}
