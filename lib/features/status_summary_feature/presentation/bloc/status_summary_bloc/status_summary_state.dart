part of 'status_summary_bloc.dart';

class StatusSummaryState {

  ///login
  final StatusSummaryStatus? statusSummaryStatus;
  final LastActivityStatus? lastActivityStatus;
  final WaterStatus? waterStatus;
  final SummaryFlowMeterStatus? reportFlowMeterStatus;
  final int selectedPage;
  final int selectedChartTab;


  StatusSummaryState({
    required this.statusSummaryStatus,
    required this.lastActivityStatus,
    required this.waterStatus,
    required this.reportFlowMeterStatus,
    required this.selectedPage,
    required this.selectedChartTab,
  });

  StatusSummaryState copyWith(
      {StatusSummaryStatus? newStatusSummaryStatus,
        LastActivityStatus? newLastActivityStatus,
        WaterStatus? newWaterStatus,
        SummaryFlowMeterStatus? newReportFlowMeterStatus,
        int? newSelectedPage,
        int? newSelectedChartTab

      }) {
    return StatusSummaryState(
        statusSummaryStatus: newStatusSummaryStatus ?? statusSummaryStatus,
      lastActivityStatus: newLastActivityStatus??lastActivityStatus,
      waterStatus: newWaterStatus??waterStatus,
      reportFlowMeterStatus: newReportFlowMeterStatus??reportFlowMeterStatus,
      selectedPage: newSelectedPage??selectedPage,
      selectedChartTab: newSelectedChartTab??selectedChartTab


    );
  }
}
