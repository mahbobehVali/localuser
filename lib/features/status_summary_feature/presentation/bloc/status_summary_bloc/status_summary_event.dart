part of 'status_summary_bloc.dart';

abstract class StatusSummaryEvent extends Equatable {
  const StatusSummaryEvent();
}

class WellsListStart extends StatusSummaryEvent {

  const WellsListStart();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LastActivityStart extends StatusSummaryEvent {
  final FlowMeterParams flowMeterParams;

  const LastActivityStart(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SocketEvent extends StatusSummaryEvent {
  final String level;
  final int areaId;

  const SocketEvent( this.level,this.areaId);

  @override
  // TODO: implement props
  List<Object?> get props => [level,areaId];
}

class ReportFlowMeter extends StatusSummaryEvent{
  final FlowMeterParams flowMeterParams;

  const ReportFlowMeter(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [flowMeterParams];

}

class FirstSwitchSummary extends StatusSummaryEvent {
  final bool isSwitch;

  const FirstSwitchSummary(this.isSwitch);

  @override
  // TODO: implement props
  List<Object?> get props => [isSwitch];
}

