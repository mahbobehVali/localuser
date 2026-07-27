
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_work_entity.dart';


abstract class WeekWellWorkStatus extends Equatable {
  const WeekWellWorkStatus();
}

class WeekWellWorkLoading extends WeekWellWorkStatus {
  @override
  List<Object> get props => [];
}

class WeekWellWorkInitial extends WeekWellWorkStatus {
  @override
  List<Object> get props => [];
}

class WeekWellWorkError extends WeekWellWorkStatus {
  final String error;

  const WeekWellWorkError(this.error);

  @override
  List<Object> get props => [error];
}

class WeekWellWorkSuccess extends WeekWellWorkStatus {
  final WellWorkEntity currentWellWorkEntity;
  final WellWorkEntity? previousWellWorkEntity;

  const WeekWellWorkSuccess({required this.currentWellWorkEntity, this.previousWellWorkEntity});


  @override
  // TODO: implement props
  List<Object?> get props =>[currentWellWorkEntity,previousWellWorkEntity];
}
