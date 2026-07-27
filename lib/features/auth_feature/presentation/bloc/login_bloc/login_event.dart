part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class ButtonLoginClicked extends LoginEvent {
  final LoginParams loginParams;

  const ButtonLoginClicked(this.loginParams);

  @override
  // TODO: implement props
  List<Object?> get props => [loginParams];
}
class ObscureClicked extends LoginEvent {
  final bool obscure;

  const ObscureClicked(this.obscure);

  @override
  // TODO: implement props
  List<Object?> get props => [obscure];
}

class ForgetClicked extends LoginEvent {
  final String mobile;

  const ForgetClicked(this.mobile);

  @override
  // TODO: implement props
  List<Object?> get props => [mobile];
}

class ForgetPassword extends LoginEvent {
  final ForgetPasswordParams forgetPasswordParams;


  const ForgetPassword(this.forgetPasswordParams);

  @override
  // TODO: implement props
  List<Object?> get props => [forgetPasswordParams];
}

