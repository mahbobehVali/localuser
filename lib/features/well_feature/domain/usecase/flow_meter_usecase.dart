
import 'package:mahaliii/features/well_feature/domain/repository/wells_repository.dart';

import '../../../../../../common/utils/data_state.dart';
import '../../../../../../common/utils/use_case.dart';
import '../../../../common/params/flowmeter_params.dart';

class WellFlowMeterUseCase extends UseCase<DataState<dynamic>,FlowMeterParams> {
  WellsRepository wellsRepository;

  WellFlowMeterUseCase(this.wellsRepository);

  @override
  Future<DataState<dynamic>> call(flowMeterParams, {bool ignoreAllWell = false}) {

    return wellsRepository.flowMeter(flowMeterParams, ignoreAllWell: ignoreAllWell);

  }


}
