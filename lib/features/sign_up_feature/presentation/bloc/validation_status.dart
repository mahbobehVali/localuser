
import 'package:equatable/equatable.dart';


abstract class SendValidationStatus extends Equatable {
  const SendValidationStatus();
}

class SendValidationInitial extends SendValidationStatus {
  @override
  List<Object> get props => [];
}

class SendValidationLoading extends SendValidationStatus {
  @override
  List<Object> get props => [];
}

class SendValidationError extends SendValidationStatus {
  final String error;

  const SendValidationError(this.error);

  @override
  List<Object> get props => [error];
}

class SendValidationSuccess extends SendValidationStatus {

  SendValidationSuccess();

  @override
  List<Object> get props => [];
}