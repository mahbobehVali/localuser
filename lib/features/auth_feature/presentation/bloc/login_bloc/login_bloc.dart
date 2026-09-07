import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/auth_feature/domain/usecase/forget_pass_usecase.dart';
import 'package:mahaliii/features/auth_feature/domain/usecase/get_code_usecase.dart';

import '../../../../../common/params/forget_password_params.dart';
import '../../../../../common/params/login_params.dart';
import '../../../../../common/utils/data_state.dart';
import '../../../../../common/utils/sharedpreference.dart';
import '../../../../../locator.dart';
import '../../../domain/entity/auth_entity.dart';
import '../../../domain/usecase/login_usecase.dart';
import 'forget_clicked_status.dart';
import 'forget_reset_status.dart';
import 'login_status.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginUseCase loginUseCase;
  GetCodeUseCase getCodeUseCase;
  ForgetPassUseCase forgetPassUseCase;

  LoginBloc(this.loginUseCase,this.getCodeUseCase,this.forgetPassUseCase)
      : super(LoginState(loginStatus: LoginInitial(),
    forgetClickedStatus: ForgetClickedInitial(),
    forgetPasswordStatus: ForgetResetInitial(),
    obscure: false
        )) {
    on<ButtonLoginClicked>((event, emit) async {
      emit(state.copyWith(newLoginStatus: LoginLoading()));

      DataState dataState = await loginUseCase(event.loginParams);

      if (dataState is DataSuccess) {
        AuthEntity authEntity = dataState.data;
        if(authEntity.userInformation==null){
          emit(state.copyWith(newLoginStatus: LoginError("خطایی رخ داده مجدد تلاش کنید")));

        }else{
          //save token
          await locator<SharedPrefOperator>().setUserToken(authEntity.accessToken??"",
              authEntity.userInformation!);

          await locator<SharedPrefOperator>().saveAlertType(authEntity.userInformation!.smsType!);

          emit(state.copyWith(newLoginStatus: LoginSuccess(dataState.data)));
        }

      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newLoginStatus: LoginError(dataState.error!)));
      }
    });
    on<ForgetClicked>((event, emit) async {

      emit(state.copyWith(newForgetClickedStatus: ForgetClickedLoading()));

      DataState dataState = await getCodeUseCase(event.mobile);

      if (dataState is DataSuccess) {


          emit(state.copyWith(newForgetClickedStatus: ForgetClickedSuccess(dataState.data)));

      }
      if (dataState is DataFailed) {
        print("dsfffffffffffffff");
        emit(state.copyWith(newForgetClickedStatus: ForgetClickedError(dataState.error??"")));
      }
    });
    on<ForgetPassword>((event, emit) async {
      emit(state.copyWith(newForgetResetStatus: ForgetPasswordLoading()));

      DataState dataState = await forgetPassUseCase(event.forgetPasswordParams);

      if (dataState is DataSuccess) {


          emit(state.copyWith(newForgetResetStatus: ForgetPasswordSuccess()));

      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newForgetResetStatus: ForgetPasswordError(dataState.error??"کداعتبار سنجی یافت نشد")));
      }
    });
    on<ObscureClicked>((event, emit) async {
      emit(state.copyWith(newObscure: event.obscure));

    });


  }
}
