part of 'well_detail_bloc.dart';

class WellDetailState {

  final FingerStatus? fingerStatus;
  final int? status;
  final bool? isSwitched;
  final AlertTypeEntity daySelected;
  final WeekWellWorkStatus? wellWorkStatus;
  final WellPerformanceStatus? wellPerformanceStatus;
  final AlertCountStatus? alertCountStatus;
  final WellStatus? wellStatus;
  final GetProgramStatus? getProgramStatus;
  final int selectedWellTab;
  final int? userLocalId;
  final String? startHour;
  final String? endHour;
  final CreateTimeStatus? createTimeStatus;
  final OnOffStatus? onOffStatus;
  final DeleteTimeStatus? deleteTimeStatus;
  final int selectedChartTab;
  final int selectedChartVolumeTab;
  final WellScreenStatus wellScreenStatus;
  final FlowMeterStatus flowMeterStatus;
  final int today;
  final FlowMeterTodayStatus flowMeterTodayStatus;

  WellDetailState({
    required this.fingerStatus,
    required this.status,
    required this.isSwitched,
    required this.daySelected,
    required this.wellWorkStatus,
    required this.wellPerformanceStatus,
    required this.alertCountStatus,
    required this.wellStatus,
    required this.getProgramStatus,
    required this.selectedWellTab,
    required this.userLocalId,
    required this.startHour,
    required this.endHour,
    required this.createTimeStatus,
    required this.onOffStatus,
    required this.deleteTimeStatus,
    required this.selectedChartTab,
    required this.selectedChartVolumeTab,
    required this.wellScreenStatus,
    required this.flowMeterStatus,
    required this.today,
    required this.flowMeterTodayStatus,
  });

  WellDetailState copyWith(
      {
        FingerStatus? newFingerStatus,
        int?newStatus,
        bool? newIsSwitched,
        AlertTypeEntity? newDaySelected,
        WeekWellWorkStatus? newWeekWellWorkStatus,
        WellPerformanceStatus? newWellPerformanceStatus,
        AlertCountStatus? newAlertCountStatus,
        WellStatus? newWellStatus,
        GetProgramStatus? newGetProgramStatus,
        int? newSelectedWellTab,
        int? newUserLocalId,
        String? newStartHour,
        String? newEndHour,
        CreateTimeStatus? newCreateTimeStatus,
        OnOffStatus? newOnOffStatus,
        DeleteTimeStatus? newDeleteTimeStatus,
        int? newSelectedChartTab,
        int? newSelectedChartVolumeTab,
        WellScreenStatus? newWellScreenStatus,
        FlowMeterStatus? newFlowMeterStatus,
        int? newToday,
        FlowMeterTodayStatus? newFlowMeterTodayStatus

      }) {
    return WellDetailState(
        fingerStatus: newFingerStatus??fingerStatus,
      status: newStatus??status,
        isSwitched: newIsSwitched??isSwitched,
      daySelected: newDaySelected??daySelected,
      wellWorkStatus: newWeekWellWorkStatus??wellWorkStatus,
      wellPerformanceStatus: newWellPerformanceStatus??wellPerformanceStatus,
      alertCountStatus: newAlertCountStatus??alertCountStatus,
      wellStatus: newWellStatus??wellStatus,
      getProgramStatus: newGetProgramStatus??getProgramStatus,
      selectedWellTab: newSelectedWellTab??selectedWellTab,
      userLocalId: newUserLocalId??userLocalId,
      startHour: newStartHour??startHour,
      endHour: newEndHour??endHour,
      createTimeStatus: newCreateTimeStatus??createTimeStatus,
      onOffStatus: newOnOffStatus??onOffStatus,
      deleteTimeStatus: newDeleteTimeStatus??deleteTimeStatus,
        selectedChartTab: newSelectedChartTab??selectedChartTab,
      selectedChartVolumeTab: newSelectedChartVolumeTab??selectedChartVolumeTab,
      wellScreenStatus: newWellScreenStatus??wellScreenStatus,
      flowMeterStatus: newFlowMeterStatus??flowMeterStatus,
      today: newToday??today,
      flowMeterTodayStatus: newFlowMeterTodayStatus??flowMeterTodayStatus

    );
  }
}

