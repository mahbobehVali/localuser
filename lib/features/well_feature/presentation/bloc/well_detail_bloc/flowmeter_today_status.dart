
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/domain/entity/signal_level_entity.dart';

abstract class SignalStatus extends Equatable {
  const SignalStatus();
}

class SignalLoading extends SignalStatus {
  @override
  List<Object> get props => [];
}

class SignalRequestAccepted extends SignalStatus {
  final int status;

  const SignalRequestAccepted(this.status);

  @override
  List<Object> get props => [status];
}
class SignalRequestFailed extends SignalStatus {
  final String error;


  const SignalRequestFailed(this.error);

  @override
  List<Object> get props => [error];
}

class SignalInitial extends SignalStatus {
  @override
  List<Object> get props => [];
}

class SignalError extends SignalStatus {
  final String error;

  const SignalError(this.error);

  @override
  List<Object> get props => [error];
}

class SignalTodayError extends SignalStatus {
  final String error;

  const SignalTodayError(this.error);

  @override
  List<Object> get props => [error];
}

class SignalSuccess extends SignalStatus {

   final SignalLevelEntity? signalLevelEntity;

  SignalSuccess([this.signalLevelEntity]);

  @override
  // TODO: implement props
  List<Object?> get props =>[signalLevelEntity];
}
