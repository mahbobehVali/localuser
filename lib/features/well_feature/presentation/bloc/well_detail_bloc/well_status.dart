
import 'package:equatable/equatable.dart';

import '../../../../status_summary_feature/domain/entity/wells_entity.dart';


abstract class WellStatus extends Equatable {
  const WellStatus();
}

class WellLoading extends WellStatus {
  @override
  List<Object> get props => [];
}
class WellExit extends WellStatus {
  @override
  List<Object> get props => [];
}

class WellError extends WellStatus {
  final String error;

  const WellError(this.error);

  @override
  List<Object> get props => [error];
}

class WellSuccess extends WellStatus {
  final List<WellsEntity> wellsEntity;

  const WellSuccess(this.wellsEntity);


  @override
  // TODO: implement props
  List<Object?> get props =>[wellsEntity];
}
