import 'package:equatable/equatable.dart';

import '../../../domain/entity/auth_entity.dart';

abstract class LoginStatus extends Equatable {
  const LoginStatus();
}

class LoginInitial extends LoginStatus {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginStatus {
  @override
  List<Object> get props => [];
}

class LoginError extends LoginStatus {
  final String error;

  const LoginError(this.error);

  @override
  List<Object> get props => [error];
}

class LoginSuccess extends LoginStatus {
  final AuthEntity authEntity;

  const LoginSuccess(this.authEntity);

  @override
  List<Object> get props => [authEntity];
}
