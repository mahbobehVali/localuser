
import 'package:mahaliii/common/params/alert_filter_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/report_repository.dart';

class ReportUseCase extends UseCase<DataState<dynamic>, AlertFilterParams> {
  ReportRepository reportRepository;

  ReportUseCase(this.reportRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(alertFilterParams) {
    return reportRepository.alerts(alertFilterParams);
  }
}
