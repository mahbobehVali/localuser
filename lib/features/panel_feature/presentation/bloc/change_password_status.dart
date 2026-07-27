import 'package:equatable/equatable.dart';

abstract class ChangePasswordStatus extends Equatable {
  const ChangePasswordStatus();
}

class ChangePasswordInitial extends ChangePasswordStatus {
  @override
  List<Object> get props => [];
}

class ChangePasswordLoading extends ChangePasswordStatus {
  @override
  List<Object> get props => [];
}

class ChangePasswordError extends ChangePasswordStatus {
  final String error;

  const ChangePasswordError(this.error);

  @override
  List<Object> get props => [error];
}

class ChangePasswordSuccess extends ChangePasswordStatus {

  const ChangePasswordSuccess();

  @override
  List<Object> get props => [];
}
