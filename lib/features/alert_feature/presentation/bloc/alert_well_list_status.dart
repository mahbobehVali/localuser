import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_entity.dart';

abstract class AlertWellListStatus extends Equatable {
  const AlertWellListStatus();
}

class AlertWellListInitial extends AlertWellListStatus {
  @override
  List<Object> get props => [];
}

class AlertWellListLoading extends AlertWellListStatus {
  @override
  List<Object> get props => [];
}
class AlertWellListExit extends AlertWellListStatus {
  @override
  List<Object> get props => [];
}

class AlertWellListError extends AlertWellListStatus {
  final String error;

  const AlertWellListError(this.error);

  @override
  List<Object> get props => [error];
}

class AlertWellListSuccess extends AlertWellListStatus {
  final List<WellsEntity> wellsEntity;

  const AlertWellListSuccess(this.wellsEntity);

  @override
  List<Object> get props => [wellsEntity];
}
