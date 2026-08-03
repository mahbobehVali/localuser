part of 'alert_bloc.dart';

sealed class AlertEvent extends Equatable {
  const AlertEvent();
}

class AlertStart extends AlertEvent{
  final AlertFilterParams alertFilterParams;
  final bool filter;

  const AlertStart({required this.alertFilterParams, this.filter=false});

  @override
  // TODO: implement props
  List<Object?> get props => [alertFilterParams,filter];

}



class AlertWellList extends AlertEvent{

  const AlertWellList();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class OneWellClicked extends AlertEvent{
  final WellsEntity wellsEntity;
  final AlertFilterModel alertFilterModel;

  const OneWellClicked(this.wellsEntity,this.alertFilterModel);

  @override
  // TODO: implement props
  List<Object?> get props => [wellsEntity,alertFilterModel];

}


class OneAlertTypeClicked extends AlertEvent{
  final AlertTypeEntity alertTypeEntity;
  final AlertFilterModel alertFilterModel;

  const OneAlertTypeClicked(this.alertTypeEntity,this.alertFilterModel);

  @override
  // TODO: implement props
  List<Object?> get props => [alertTypeEntity,alertFilterModel];

}

class OneAlertStatusClicked extends AlertEvent{
  final AlertTypeEntity alertStatusEntity;
  final AlertFilterModel alertFilterModel;


  const OneAlertStatusClicked(this.alertStatusEntity,this.alertFilterModel);

  @override
  // TODO: implement props
  List<Object?> get props => [alertStatusEntity,alertFilterModel];

}

class AlertChangeDate extends AlertEvent{
  final String startDate;
  final String endDate;
  final AlertFilterModel alertFilterModel;

  const AlertChangeDate(this.startDate,this.endDate,this.alertFilterModel);

  @override
  // TODO: implement props
  List<Object?> get props => [startDate,endDate,alertFilterModel];

}

// وقتی کاربر دکمه اعمال فیلتر را در دیالوگ می‌زند
class ApplyFilterEvent extends AlertEvent {
  final AlertFilterModel filter;
  const ApplyFilterEvent(this.filter);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
// وقتی کاربر روی ضربدر یک تگ کلیک می‌کند
class RemoveSingleFilterEvent extends AlertEvent {
  final AlertFilterModel filter;
  const RemoveSingleFilterEvent(this.filter);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AlertDetailEvent extends AlertEvent {
  final int id;
  final int status;
  const AlertDetailEvent(this.id,this.status);

  @override
  // TODO: implement props
  List<Object?> get props => [id,status];
}

class AlertCreateEvent extends AlertEvent {
  final SendNewSupportParams sendNewSupportParams;
  const AlertCreateEvent(this.sendNewSupportParams);

  @override
  // TODO: implement props
  List<Object?> get props => [sendNewSupportParams];
}


class ChangeAlert extends AlertEvent {
  final int status;
  const ChangeAlert(this.status);

  @override
  // TODO: implement props
  List<Object?> get props => [status];
}