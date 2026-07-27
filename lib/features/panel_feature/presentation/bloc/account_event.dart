part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();
}

class SendSmsEvent extends AccountEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class ChangePasswordEvent extends AccountEvent{
  final ChangePasswordParams changePasswordParams;


  const ChangePasswordEvent(this.changePasswordParams);

  @override
  // TODO: implement props
  List<Object?> get props => [changePasswordParams];

}

class ChangeEditEvent extends AccountEvent{
  final bool edit;


  const ChangeEditEvent(this.edit);

  @override
  // TODO: implement props
  List<Object?> get props => [edit];

}

class ChangeSelectedRadio extends AccountEvent{
  final int selectedRadio;


  const ChangeSelectedRadio(this.selectedRadio);

  @override
  // TODO: implement props
  List<Object?> get props => [selectedRadio];

}

class ChangeAlert extends AccountEvent{
  final int type;


  const ChangeAlert(this.type);

  @override
  // TODO: implement props
  List<Object?> get props => [type];

}
