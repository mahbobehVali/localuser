
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_work_entity.dart';


abstract class SectionWellWorkStatus extends Equatable {
  const SectionWellWorkStatus();
}

class SectionWellWorkLoading extends SectionWellWorkStatus {
  @override
  List<Object> get props => [];
}

class SectionWellWorkInitial extends SectionWellWorkStatus {
  @override
  List<Object> get props => [];
}

class SectionWellWorkError extends SectionWellWorkStatus {
  final String error;

  const SectionWellWorkError(this.error);

  @override
  List<Object> get props => [error];
}

class SectionWellWorkSuccess extends SectionWellWorkStatus {
  final WellWorkEntity currentWellWorkEntity;
  final WellWorkEntity? previousWellWorkEntity;

  const SectionWellWorkSuccess({required this.currentWellWorkEntity, this.previousWellWorkEntity});


  @override
  // TODO: implement props
  List<Object?> get props =>[currentWellWorkEntity,previousWellWorkEntity];
}
