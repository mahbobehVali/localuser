
import 'package:mahaliii/features/well_feature/domain/repository/wells_repository.dart';

import '../../../../../../common/utils/data_state.dart';
import '../../../../../../common/utils/use_case.dart';
import '../../../../common/params/flowmeter_params.dart';

class WellWorkHourUseCase extends UseCase<DataState<dynamic>,FlowMeterParams> {
  WellsRepository wellsRepository;

  WellWorkHourUseCase(this.wellsRepository);

  @override
  Future<DataState<dynamic>> call(flowMeterParams) {

    return wellsRepository.wellWorkHour(flowMeterParams);

  }


}
