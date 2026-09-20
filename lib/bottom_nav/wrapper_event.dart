part of 'wrapper_bloc.dart';

sealed class WrapperEvent extends Equatable {
  const WrapperEvent();
}

class AutoWrapperSwitchChange extends WrapperEvent {


  const AutoWrapperSwitchChange();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeNav extends WrapperEvent {
  final int value;


  const ChangeNav(this.value);

  @override
  // TODO: implement props
  List<Object?> get props => [value];
}

class SetInitialWellsEvent extends WrapperEvent {
  final List<WellsEntity> wellsList; // فرض بر اینکه مدل شما WellsEntity است
  SetInitialWellsEvent(this.wellsList);

  @override
  // TODO: implement props
  List<Object?> get props => [wellsList];
}

// رویداد جدید: تغییر وضعیت یک چاه
class UpdateWellStatusEvent extends WrapperEvent {
  final int wellId;
  final int status; // 0: خاموش, 1: روشن, غیره
  UpdateWellStatusEvent({required this.wellId, required this.status});

  @override
  // TODO: implement props
  List<Object?> get props =>[wellId,status];
}