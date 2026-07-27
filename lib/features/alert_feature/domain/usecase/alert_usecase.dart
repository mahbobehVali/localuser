
import 'package:mahaliii/common/params/alert_filter_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/alert_repository.dart';

class AlertUseCase extends UseCase<DataState<dynamic>, AlertFilterParams> {
  AlertRepository alertRepository;

  AlertUseCase(this.alertRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(page) {
    return alertRepository.alerts(page);
  }
}
