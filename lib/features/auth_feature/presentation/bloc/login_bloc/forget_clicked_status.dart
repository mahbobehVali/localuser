import 'package:equatable/equatable.dart';

abstract class ForgetClickedStatus extends Equatable {
  const ForgetClickedStatus();
}

class ForgetClickedInitial extends ForgetClickedStatus {
  @override
  List<Object> get props => [];
}

class ForgetClickedLoading extends ForgetClickedStatus {
  @override
  List<Object> get props => [];
}

class ForgetClickedError extends ForgetClickedStatus {
  final String error;

  const ForgetClickedError(this.error);

  @override
  List<Object> get props => [error];
}

class ForgetClickedSuccess extends ForgetClickedStatus {
  final int code;
  const ForgetClickedSuccess(this.code);

  @override
  List<Object> get props => [code];
}
