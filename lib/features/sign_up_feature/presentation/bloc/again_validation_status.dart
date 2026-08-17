
import 'package:equatable/equatable.dart';


abstract class AgainSendValidationStatus extends Equatable {
  const AgainSendValidationStatus();
}

class AgainSendValidationInitial extends AgainSendValidationStatus {
  @override
  List<Object> get props => [];
}

class AgainSendValidationLoading extends AgainSendValidationStatus {
  @override
  List<Object> get props => [];
}

class AgainSendValidationError extends AgainSendValidationStatus {
  final String error;

  const AgainSendValidationError(this.error);

  @override
  List<Object> get props => [error];
}

class AgainSendValidationSuccess extends AgainSendValidationStatus {
  int id;

  AgainSendValidationSuccess(this.id);

  @override
  List<Object> get props => [id];
}