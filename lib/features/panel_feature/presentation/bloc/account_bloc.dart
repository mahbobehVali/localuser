import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mahaliii/common/params/change_password_params.dart';
import 'package:mahaliii/features/panel_feature/domain/usecase/change_alert_usecase.dart';
import 'package:mahaliii/features/panel_feature/domain/usecase/send_sms_usecase.dart';
import 'package:mahaliii/features/panel_feature/presentation/bloc/send_sms_status.dart';

import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/sharedpreference.dart';
import '../../../../common/utils/use_case.dart';
import '../../../../locator.dart';
import '../../domain/usecase/change_password_usecase.dart';
import 'change_alert_status.dart';
import 'change_password_status.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  SendSmsUseCase sendSmsUseCase;
  ChangePasswordUseCase changePasswordUseCase;
  ChangeAlertUseCase changeAlertUseCase;
  AccountBloc(this.sendSmsUseCase,this.changePasswordUseCase,this.changeAlertUseCase) : super(
      AccountState(sendSmsStatus: SendSmsInitial(),
      changePasswordStatus: ChangePasswordInitial(),
  changeAlertStatus: ChangeAlertInitial(),
  //
  alertSendType: 1,
  selectedRadio: 0,
  edit: false)) {
    on<SendSmsEvent>((event, emit) async {
      emit(state.copyWith(newSendSmsStatus: SendSmsLoading()));

      DataState dataState = await sendSmsUseCase(NoParams());

      if (dataState is DataSuccess) {
        emit(state.copyWith(newSendSmsStatus: SendSmsSuccess(dataState.data)));

      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          emit(state.copyWith(newSendSmsStatus: SendSmsExit()));
        }else {
          emit(
              state.copyWith(newSendSmsStatus: SendSmsError(dataState.error!)));
        }      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(state.copyWith(newChangePasswordStatus: ChangePasswordLoading()));

      DataState dataState = await changePasswordUseCase(event.changePasswordParams);

      if (dataState is DataSuccess) {

          emit(
              state.copyWith(newChangePasswordStatus: ChangePasswordSuccess()));

      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          emit(state.copyWith(newChangePasswordStatus: ChangePasswordExit()));
        }else {
          emit(state.copyWith(
              newChangePasswordStatus: ChangePasswordError(dataState.error!)));
        }      }
    });
    on<ChangeEditEvent>((event, emit) async {
      emit(state.copyWith(newEdit: event.edit));


    });
    on<ChangeSelectedRadio>((event, emit) async {
      emit(state.copyWith(newSelectedRadio: event.selectedRadio));

    });
    on<ChangeAlert>((event, emit) async {
      await locator<SharedPrefOperator>().saveAlertType(event.type);
      emit(state.copyWith(newSelectedRadio: event.type,
          newChangeAlertStatus: ChangeAlertLoading()));

      DataState dataState = await changeAlertUseCase(event.type);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newChangeAlertStatus: ChangeAlertSuccess(dataState.data["message"])));

      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          emit(state.copyWith(newChangeAlertStatus: ChangeAlertExit()));
        }else {
          emit(state.copyWith(
              newChangeAlertStatus: ChangeAlertError(dataState.error!)));
        }      }

    });
  }
}
