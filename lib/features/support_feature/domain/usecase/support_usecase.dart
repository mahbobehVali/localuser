
import 'package:mahaliii/common/params/flowmeter_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/support_repository.dart';

class SupportUseCase extends UseCase<DataState<dynamic>, FlowMeterParams> {
  SupportRepository supportRepository;

  SupportUseCase(this.supportRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(flowMeterParams) {
    return supportRepository.getSupportMessage(flowMeterParams);
  }
}
