
import 'package:mahaliii/common/params/flowmeter_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/report_repository.dart';

class GetCapacityUseCase extends UseCase<DataState<dynamic>, FlowMeterParams> {
  ReportRepository reportRepository;

  GetCapacityUseCase(this.reportRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(flowMeterParams) {
    return reportRepository.getCapacity(flowMeterParams);
  }
}
