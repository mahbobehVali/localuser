
import 'package:equatable/equatable.dart';

abstract class RegisterStatus extends Equatable{}

class RegisterInitial extends RegisterStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RegisterLoading extends RegisterStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RegisterComplete extends RegisterStatus {

  RegisterComplete();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RegisterError extends RegisterStatus {
  final String error;

   RegisterError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
