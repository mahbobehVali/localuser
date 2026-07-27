
import 'package:mahaliii/features/status_summary_feature/domain/repository/status_summary_repository.dart';

import '../../../../../../common/utils/data_state.dart';
import '../../../../../../common/utils/use_case.dart';
import '../../../../common/params/flowmeter_params.dart';

class ReportFlowMeterUseCase extends UseCase<DataState<dynamic>,FlowMeterParams> {
  StatusSummaryRepository statusSummaryRepository;

  ReportFlowMeterUseCase(this.statusSummaryRepository);

  @override
  Future<DataState<dynamic>> call(flowMeterParams) {

    return statusSummaryRepository.flowMeter(flowMeterParams);

  }


}
