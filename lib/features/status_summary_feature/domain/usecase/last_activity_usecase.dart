
import '../../../../common/params/flowmeter_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/status_summary_repository.dart';

class LastActivityUseCase extends UseCase<DataState<dynamic>, FlowMeterParams> {
  StatusSummaryRepository statusSummaryRepository;

  LastActivityUseCase(this.statusSummaryRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(flowMeterParams) {
    return statusSummaryRepository.lastActivities(flowMeterParams);
  }
}
