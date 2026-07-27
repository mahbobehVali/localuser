part of 'account_bloc.dart';

// sealed class PanelState extends Equatable {
//   const PanelState();
// }
//
// final class PanelInitial extends PanelState {
//   @override
//   List<Object> get props => [];
// }

class AccountState {

  ///login
  final SendSmsStatus? sendSmsStatus;
  final ChangePasswordStatus? changePasswordStatus;
  final bool edit;
  final int selectedRadio;
  final int alertSendType;
  final ChangeAlertStatus changeAlertStatus;

  AccountState({
    required this.sendSmsStatus,
    required this.changePasswordStatus,
    required this.edit,
    required this.selectedRadio,
    required this.alertSendType,
    required this.changeAlertStatus,
  });

  AccountState copyWith(
      {SendSmsStatus? newSendSmsStatus,
        ChangePasswordStatus? newChangePasswordStatus,
        bool? newEdit,
         int? newSelectedRadio,
        int? newAlertSendType,
        ChangeAlertStatus? newChangeAlertStatus


      }) {
    return AccountState(
        sendSmsStatus: newSendSmsStatus ?? sendSmsStatus,
        changePasswordStatus: newChangePasswordStatus??changePasswordStatus,
      edit: newEdit??edit,
      selectedRadio: newSelectedRadio??selectedRadio,
      alertSendType: newAlertSendType??alertSendType,
      changeAlertStatus: newChangeAlertStatus??changeAlertStatus


    );
  }
}
