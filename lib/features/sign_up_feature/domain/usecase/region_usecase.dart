

import '../../../../../../common/utils/data_state.dart';
import '../../../../../../common/utils/use_case.dart';
import '../repository/sign_up_repository.dart';

class RegionUseCase extends UseCase<DataState<dynamic>,NoParams> {
  SignUpRepository mainRepository;

  RegionUseCase(this.mainRepository);

  @override
  Future<DataState<dynamic>> call(NoParams noParams) {
    return mainRepository.getRegions();

  }


}