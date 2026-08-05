
import 'package:equatable/equatable.dart';

import '../../../domain/entity/well_flowmeter_one_entity.dart';

abstract class FlowMeterTodayStatus extends Equatable {
  const FlowMeterTodayStatus();
}

class FlowMeterTodayLoading extends FlowMeterTodayStatus {
  @override
  List<Object> get props => [];
}

class FlowMeterTodayRequestAccepted extends FlowMeterTodayStatus {
  final int status;

  const FlowMeterTodayRequestAccepted(this.status);

  @override
  List<Object> get props => [status];
}
class FlowMeterTodayRequestFailed extends FlowMeterTodayStatus {
  final String error;


  const FlowMeterTodayRequestFailed(this.error);

  @override
  List<Object> get props => [error];
}

class FlowMeterTodayInitial extends FlowMeterTodayStatus {
  @override
  List<Object> get props => [];
}

class FlowMeterTodayError extends FlowMeterTodayStatus {
  final String error;

  const FlowMeterTodayError(this.error);

  @override
  List<Object> get props => [error];
}

class FlowMeterTodayTodayError extends FlowMeterTodayStatus {
  final String error;

  const FlowMeterTodayTodayError(this.error);

  @override
  List<Object> get props => [error];
}

class FlowMeterTodaySuccess extends FlowMeterTodayStatus {
  final WellFlowMeterOneEntity? wellFlowMeterTodayOneEntity;


  const FlowMeterTodaySuccess({ this.wellFlowMeterTodayOneEntity});

  // // متد copyWith برای اینکه وقتی یکی آمد، قبلی پاک نشود
  // FlowMeterTodaySuccess copyWith({
  //   int? newStatus,
  // }) {
  //   return FlowMeterTodaySuccess(
  //     status: newStatus ?? status,
  //   );
  // }

  @override
  // TODO: implement props
  List<Object?> get props =>[wellFlowMeterTodayOneEntity];
}
