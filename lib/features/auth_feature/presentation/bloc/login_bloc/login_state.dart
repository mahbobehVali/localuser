part of 'login_bloc.dart';

class LoginState {

  ///login
  final LoginStatus? loginStatus;
  final bool obscure;
  final ForgetClickedStatus forgetClickedStatus;
  final ForgetPasswordStatus forgetPasswordStatus;

  LoginState({
    required this.loginStatus,
    required this.obscure,
    required this.forgetClickedStatus,
    required this.forgetPasswordStatus,
  });

  LoginState copyWith(
      {LoginStatus? newLoginStatus,
        bool? newObscure,
        ForgetClickedStatus? newForgetClickedStatus,
        ForgetPasswordStatus? newForgetResetStatus

      }) {
    return LoginState(
        loginStatus: newLoginStatus ?? loginStatus,
      obscure: newObscure??obscure,
      forgetClickedStatus: newForgetClickedStatus??forgetClickedStatus,
      forgetPasswordStatus: newForgetResetStatus??forgetPasswordStatus


    );
  }
}
