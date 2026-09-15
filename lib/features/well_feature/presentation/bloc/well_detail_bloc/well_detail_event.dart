part of 'well_detail_bloc.dart';

sealed class WellDetailEvent extends Equatable {
  const WellDetailEvent();
}


class FingerSocketEvent extends WellDetailEvent {
  final String pin;
  final int deviceId;

  const FingerSocketEvent( this.pin,this.deviceId);

  @override
  // TODO: implement props
  List<Object?> get props => [pin,deviceId];
}

class StatusEvent extends WellDetailEvent {
  final int status;

  const StatusEvent( this.status);

  @override
  // TODO: implement props
  List<Object?> get props => [status];
}

class SwitchClicked extends WellDetailEvent {
  final bool isSwitch;
  final CreateTimeParams createTimeParams;

  const SwitchClicked(this.isSwitch,this.createTimeParams);

  @override
  // TODO: implement props
  List<Object?> get props => [isSwitch,createTimeParams];
}

class AutoSwitchChange extends WellDetailEvent {


  const AutoSwitchChange();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AutomaticSwitch extends WellDetailEvent {

  const AutomaticSwitch();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FirstSwitch extends WellDetailEvent {
  final bool isSwitch;

  const FirstSwitch(this.isSwitch);

  @override
  // TODO: implement props
  List<Object?> get props => [isSwitch];
}

class DayClicked extends WellDetailEvent {
  final AlertTypeEntity alertTypeEntity;

 const DayClicked(this.alertTypeEntity);

  @override
  // TODO: implement props
   List<Object?> get props => [alertTypeEntity];
}

class WellWorkHourStart extends WellDetailEvent {
  final FlowMeterParams flowMeterParams;

  const WellWorkHourStart(this.flowMeterParams);

  @override
  // TODO: implement props
   List<Object?> get props => [flowMeterParams];
}


class WellPerformance extends WellDetailEvent {
  final FlowMeterParams flowMeterParams;

  const WellPerformance(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [flowMeterParams];
}
class AlertCount extends WellDetailEvent {
  final FlowMeterParams flowMeterParams;

  const AlertCount(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [flowMeterParams];
}

class PumpPerformanceStart extends WellDetailEvent {
  final FlowMeterParams flowMeterParams;

  const PumpPerformanceStart(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [flowMeterParams];
}

class AlertCountStart extends WellDetailEvent {
 final FlowMeterParams flowMeterParams;

  const AlertCountStart(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [flowMeterParams];
}

class WellStart extends WellDetailEvent {

  const WellStart();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetProgram extends WellDetailEvent {
  final int id;

  const GetProgram(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class ChangeWellTab extends WellDetailEvent {
  final int selectedTabIndex;

  const ChangeWellTab(this.selectedTabIndex);

  @override
  // TODO: implement props
  List<Object?> get props => [selectedTabIndex];
}
class ChangeUserLocalId extends WellDetailEvent {
  final int? userLocalId;

  const ChangeUserLocalId(this.userLocalId);

  @override
  // TODO: implement props
  List<Object?> get props => [userLocalId];
}


class ChangeStartClock extends WellDetailEvent {
  final String startHour;
  const ChangeStartClock(this.startHour);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeEndClock extends WellDetailEvent {
  final String endHour;
  const ChangeEndClock(this.endHour);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CreateNewTime extends WellDetailEvent {
  final CreateTimeParams createTimeParams;

   const CreateNewTime(this.createTimeParams);

  @override
  // TODO: implement props
  List<Object?> get props => [createTimeParams];
}

class DeleteTime extends WellDetailEvent {
  final CreateTimeParams createTimeParams;

  const DeleteTime(this.createTimeParams);

  @override
  // TODO: implement props
  List<Object?> get props => [createTimeParams];
}

class ResetOnOffStatus extends WellDetailEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ResetCreateTimeStatus extends WellDetailEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ResetDeleteStatus extends WellDetailEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FlowMeterEvent extends WellDetailEvent {
  final FlowMeterParams flowMeterParams;

  const FlowMeterEvent(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FlowMeterToday extends WellDetailEvent {

  const FlowMeterToday();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// ایونت داخلی برای دیتای سوکت
class InternalPumpDataReceived extends WellDetailEvent {
  final dynamic onOff;
  InternalPumpDataReceived(this.onOff);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// ایونت خطای داخلی سوکت
class InternalPumpErrorOccurred extends WellDetailEvent {
  final String error;
  InternalPumpErrorOccurred(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


