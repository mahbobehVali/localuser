import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/last_activity_entity.dart';

abstract class LastActivityStatus extends Equatable {
  const LastActivityStatus();
}

class LastActivityInitial extends LastActivityStatus {
  @override
  List<Object> get props => [];
}

class LastActivityLoading extends LastActivityStatus {
  @override
  List<Object> get props => [];
}

class LastActivityError extends LastActivityStatus {
  final String error;

  const LastActivityError(this.error);

  @override
  List<Object> get props => [error];
}

class LastActivitySuccess extends LastActivityStatus {
  final LastActivityEntity lastActivityEntity;

  const LastActivitySuccess(this.lastActivityEntity);

  @override
  List<Object> get props => [lastActivityEntity];
}

class LastActivityEmpty extends LastActivityStatus {

  const LastActivityEmpty();

  @override
  List<Object> get props => [];
}
