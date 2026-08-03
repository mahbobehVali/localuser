
import 'package:mahaliii/common/params/send_new_request_to_support_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/alert_repository.dart';

class AlertCreateUseCase extends UseCase<DataState<dynamic>, SendNewSupportParams> {
  AlertRepository alertRepository;

  AlertCreateUseCase(this.alertRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(SendNewSupportParams sendNewSupportParams) {
    return alertRepository.alertCreate(sendNewSupportParams);
  }
}
