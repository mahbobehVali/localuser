part of 'report_bloc.dart';

sealed class ReportEvent extends Equatable {
  const ReportEvent();
}

class StartReport extends ReportEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class WellSelected extends ReportEvent {
  final List<int> wellsDataEntity;

  const WellSelected(this.wellsDataEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeDate extends ReportEvent {
  final String startDate;
  final String endDate;

  const ChangeDate(this.startDate,this.endDate);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeStartClock extends ReportEvent {
  final String startHour;
  const ChangeStartClock(this.startHour);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeEndClock extends ReportEvent {
  final String endHour;
  const ChangeEndClock(this.endHour);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetAlertCount extends ReportEvent {
  final FlowMeterParams flowMeterParams;
  const GetAlertCount(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReportFlowMeter extends ReportEvent {
  final FlowMeterParams flowMeterParams;
  const ReportFlowMeter(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReportDetailFlowMeter extends ReportEvent {
  final FlowMeterParams flowMeterParams;
  const ReportDetailFlowMeter(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReportCommand extends ReportEvent {
  final FlowMeterParams flowMeterParams;
  const ReportCommand(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OneReportIndexClicked extends ReportEvent {
  final AlertTypeEntity alertTypeEntity;
  const OneReportIndexClicked(this.alertTypeEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [alertTypeEntity];
}

class SearchClicked extends ReportEvent {
  // final FlowMeterParams flowMeterParams;
  const SearchClicked();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserActivityReportStart extends ReportEvent {
  final FlowMeterParams flowMeterParams;
  const UserActivityReportStart(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [flowMeterParams];
}


