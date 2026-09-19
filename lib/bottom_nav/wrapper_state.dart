part of 'wrapper_bloc.dart';


class WrapperState extends Equatable {
  final OnOffWrapperStatus onOffWrapperStatus;
  final bool isSwitched;
  final int nav;

  const WrapperState({
    required this.onOffWrapperStatus,
    required this.isSwitched,
    required this.nav,
  });

  WrapperState copyWith({
    OnOffWrapperStatus? newOnOffWrapperStatus,
    bool? newIsSwitched,
    int? newNav,
  }) {
    return WrapperState(
      onOffWrapperStatus: newOnOffWrapperStatus ?? this.onOffWrapperStatus,
      isSwitched: newIsSwitched ?? this.isSwitched,
      nav: newNav ?? this.nav,
    );
  }

  @override
  List<Object?> get props => [onOffWrapperStatus, isSwitched, nav];
}
