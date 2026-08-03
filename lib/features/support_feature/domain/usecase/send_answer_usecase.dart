
import 'package:mahaliii/common/params/send_new_request_to_support_params.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../repository/support_repository.dart';

class SendAnswerUseCase extends UseCase<DataState<dynamic>, SendNewSupportParams> {
  SupportRepository supportRepository;

  SendAnswerUseCase(this.supportRepository);

  // static ValueNotifier<AuthEntity?> authNotifier=ValueNotifier(null);

  @override
  Future<DataState> call(sendNewSupportParams) {
    return supportRepository.sendAnswer(sendNewSupportParams);
  }
}
