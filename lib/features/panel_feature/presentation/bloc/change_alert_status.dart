import 'package:equatable/equatable.dart';

abstract class ChangeAlertStatus extends Equatable {
  const ChangeAlertStatus();
}

class ChangeAlertInitial extends ChangeAlertStatus {
  @override
  List<Object> get props => [];
}

class ChangeAlertLoading extends ChangeAlertStatus {
  @override
  List<Object> get props => [];
}

class ChangeAlertError extends ChangeAlertStatus {
  final String error;

  const ChangeAlertError(this.error);

  @override
  List<Object> get props => [error];
}

class ChangeAlertSuccess extends ChangeAlertStatus {
  final String message;

  const ChangeAlertSuccess(this.message);

  @override
  List<Object> get props => [message];
}
