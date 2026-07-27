
import 'package:mahaliii/features/sign_up_feature/domain/repository/sign_up_repository.dart';

import '../../../../../../common/utils/data_state.dart';
import '../../../../../../common/utils/use_case.dart';

class AreaUseCase extends UseCase<DataState<dynamic>,int> {
  SignUpRepository mainRepository;

  AreaUseCase(this.mainRepository);

  @override
  Future<DataState<dynamic>> call(id) {
    return mainRepository.getArea(id);

  }


}
