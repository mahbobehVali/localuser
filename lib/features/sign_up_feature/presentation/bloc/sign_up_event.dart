part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();
}

class FirstSignUpButtonClicked extends SignUpEvent {
  final SignUpParams signUpParams;

  const FirstSignUpButtonClicked(this.signUpParams);

  @override
  // TODO: implement props
  List<Object?> get props => [signUpParams];
}

class ValidationButtonClicked extends SignUpEvent {
  final ValidationParams validationParams;

  const ValidationButtonClicked(this.validationParams);

  @override
  // TODO: implement props
  List<Object?> get props => [validationParams];
}
class AgainSendValidationButtonClicked extends SignUpEvent {

  const AgainSendValidationButtonClicked();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class RegisterClicked extends SignUpEvent {
  final SignUpParams signUpParams;


  const RegisterClicked(this.signUpParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeParams extends SignUpEvent {
  final ChangeAlertParams changeAlertParams;


  const ChangeParams(this.changeAlertParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class SaveServerId extends SignUpEvent {
  final SignUpParams signUpParams;


  const SaveServerId(this.signUpParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FillValidId extends SignUpEvent {
  final int id;

  const FillValidId(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class GetArea extends SignUpEvent{
  final int id;

  const GetArea(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];

}


class GetRegion extends SignUpEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class OneAreaClicked extends SignUpEvent{
  final AreaEntity areaEntity;

  const OneAreaClicked(this.areaEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [areaEntity];

}


class OneRegionClicked extends SignUpEvent{
  final RegionEntity regionEntity;

  const OneRegionClicked(this.regionEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [regionEntity];

}

class ResponsibilityChanged extends SignUpEvent{
  final AlertTypeEntity responsibilityEntity;

  const ResponsibilityChanged(this.responsibilityEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [responsibilityEntity];

}

class FillUserValidationId extends SignUpEvent {

  int id;

  FillUserValidationId(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class SendValidation extends SignUpEvent {

  SignUpParams signUpParams;

  SendValidation(this.signUpParams);

  @override
  // TODO: implement props
  List<Object?> get props => [signUpParams];
}



