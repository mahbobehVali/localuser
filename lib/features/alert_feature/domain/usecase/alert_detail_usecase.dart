
import 'package:mahaliii/common/params/alert_filter_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/alert_repository.dart';

class AlertDetailUseCase extends UseCase<DataState<dynamic>, int> {
  AlertRepository alertRepository;

  AlertDetailUseCase(this.alertRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(int id) {
    return alertRepository.detailAlert(id);
  }
}
