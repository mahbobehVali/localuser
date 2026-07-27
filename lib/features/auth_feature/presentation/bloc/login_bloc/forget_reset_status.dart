import 'package:equatable/equatable.dart';

abstract class ForgetPasswordStatus extends Equatable {
  const ForgetPasswordStatus();
}

class ForgetResetInitial extends ForgetPasswordStatus {
  @override
  List<Object> get props => [];
}

class ForgetPasswordLoading extends ForgetPasswordStatus {
  @override
  List<Object> get props => [];
}

class ForgetPasswordError extends ForgetPasswordStatus {
  final String error;

  const ForgetPasswordError(this.error);

  @override
  List<Object> get props => [error];
}

class ForgetPasswordSuccess extends ForgetPasswordStatus {

  const ForgetPasswordSuccess();

  @override
  List<Object> get props => [];
}
