import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_entity.dart';

abstract class StatusSummaryStatus extends Equatable {
  const StatusSummaryStatus();
}

class StatusSummaryInitial extends StatusSummaryStatus {
  @override
  List<Object> get props => [];
}

class StatusSummaryLoading extends StatusSummaryStatus {
  @override
  List<Object> get props => [];
}
class StatusSummaryExit extends StatusSummaryStatus {
  @override
  List<Object> get props => [];
}

class StatusSummaryError extends StatusSummaryStatus {
  final String error;

  const StatusSummaryError(this.error);

  @override
  List<Object> get props => [error];
}

class StatusSummarySuccess extends StatusSummaryStatus {
  final List<WellsEntity> wellsEntity;

  const StatusSummarySuccess(this.wellsEntity);

  @override
  List<Object> get props => [wellsEntity];
}
