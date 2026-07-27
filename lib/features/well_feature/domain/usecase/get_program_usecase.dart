
import 'package:mahaliii/features/well_feature/domain/repository/wells_repository.dart';

import '../../../../../../common/utils/data_state.dart';
import '../../../../../../common/utils/use_case.dart';

class GetProgramUseCase extends UseCase<DataState<dynamic>,int> {
  WellsRepository wellsRepository;

  GetProgramUseCase(this.wellsRepository);

  @override
  Future<DataState<dynamic>> call(id) {

    return wellsRepository.getProgramList(id);

  }


}
