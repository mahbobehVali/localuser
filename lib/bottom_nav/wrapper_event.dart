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