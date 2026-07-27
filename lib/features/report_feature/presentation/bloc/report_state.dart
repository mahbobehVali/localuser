part of 'report_bloc.dart';


class ReportState {
  // final String? selectedWell;
  final List<String>? wells;
  final List<int> oneWell;
  final WellReportStatus? wellReportStatus;
  final String startDate;
  final String startHour;
  final String endDate;
  final String endHour;
  final ReportCountStatus? reportCountStatus;
  final ReportFlowMeterStatus? reportFlowMeterStatus;
  final ReportCommandStatus? reportCommandStatus;
  final List<AlertTypeEntity> reportIndexList;
  final int? selectedReportIndex;
  final FlowMeterParams? flowMeterParams;
  final UserActivityReportStatus? userActivityReportStatus;
  final int? selectedLastActivityPage;


  ReportState({
    // required this.selectedWell,
    required this.wells,
    required this.oneWell,
    required this.wellReportStatus,
    required this.startDate,
    required this.startHour,
    required this.endDate,
    required this.endHour,
    required this.reportCountStatus,
    required this.reportFlowMeterStatus,
    required this.reportCommandStatus,
    required this.reportIndexList,
    required this.selectedReportIndex,
    required this.flowMeterParams,
    required this.userActivityReportStatus,
    required this.selectedLastActivityPage,
  });

  ReportState copyWith(
      {
        // String? newSelectedWell,
        List<String>? newWells,
        List<int>? newOneWell,
        WellReportStatus? newWellReportStatus,
        String? newStartDate,
        String? newStartHour,
        String? newEndDate,
        String? newEndHour,
        ReportCountStatus? newReportCountStatus,
        ReportFlowMeterStatus? newReportFlowMeterStatus,
        ReportCommandStatus? newReportCommandStatus,
         List<AlertTypeEntity>? newReportIndexList,
         int? newSelectedReportIndex,
        FlowMeterParams? newFlowMeterParams,
        UserActivityReportStatus? newUserActivityReportStatus,
        int? newSelectedLastActivityPage,

      }) {
    return ReportState(
        // selectedWell: newSelectedWell??selectedWell,
        wells: newWells??wells,
        oneWell: newOneWell??oneWell,
      wellReportStatus: newWellReportStatus??wellReportStatus,
      startHour: newStartHour??startHour,
        endHour: newEndHour??endHour,
      startDate: newStartDate??startDate,
      endDate: newEndDate??endDate,
      reportCountStatus: newReportCountStatus??reportCountStatus,
      reportFlowMeterStatus: newReportFlowMeterStatus??reportFlowMeterStatus,
      reportCommandStatus: newReportCommandStatus??reportCommandStatus,
      reportIndexList: newReportIndexList??reportIndexList,
      selectedReportIndex: newSelectedReportIndex??selectedReportIndex,
      flowMeterParams: newFlowMeterParams??flowMeterParams,
      userActivityReportStatus: newUserActivityReportStatus??userActivityReportStatus,
      selectedLastActivityPage: newSelectedLastActivityPage??selectedLastActivityPage,
    );
  }
}
