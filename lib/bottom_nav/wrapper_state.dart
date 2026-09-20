part of 'wrapper_bloc.dart';


class WrapperState extends Equatable {
  final OnOffWrapperStatus onOffWrapperStatus;
  final bool? isSwitched;
  final int nav;
  final Map<int, bool> wellsStatusMap;
  final List<WellsEntity> wells; // لیست چاه‌ها;

  const WrapperState({
    required this.onOffWrapperStatus,
    required this.isSwitched,
    required this.nav,
    required this.wellsStatusMap,
    required this.wells,
  });

  WrapperState copyWith({
    OnOffWrapperStatus? newOnOffWrapperStatus,
    bool? newIsSwitched,
    int? newNav,
    Map<int, bool>? newWellsStatusMap,
    List<WellsEntity>? newWells,
  }) {
    return WrapperState(
      onOffWrapperStatus: newOnOffWrapperStatus ?? this.onOffWrapperStatus,
      isSwitched: newIsSwitched ?? this.isSwitched,
      nav: newNav ?? this.nav,
      wellsStatusMap: newWellsStatusMap??wellsStatusMap,
      wells: newWells ?? wells,
    );
  }

  @override
  List<Object?> get props => [onOffWrapperStatus, isSwitched, nav,wells];
}
