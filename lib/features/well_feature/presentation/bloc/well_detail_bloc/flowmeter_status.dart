
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/data/model/well_flowmeter_one_model.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_flowmeter_one_entity.dart';

import '../../../domain/entity/well_flowmeter_entity.dart';

abstract class FlowMeterStatus extends Equatable {
  const FlowMeterStatus();
}

class FlowMeterLoading extends FlowMeterStatus {
  @override
  List<Object> get props => [];
}

class FlowMeterRequestAccepted extends FlowMeterStatus {
  final int status;

  const FlowMeterRequestAccepted(this.status);

  @override
  List<Object> get props => [status];
}
class FlowMeterRequestFailed extends FlowMeterStatus {
  final String error;


  const FlowMeterRequestFailed(this.error);

  @override
  List<Object> get props => [error];
}

class FlowMeterInitial extends FlowMeterStatus {
  @override
  List<Object> get props => [];
}
class FlowMeterEmpty extends FlowMeterStatus {
  @override
  List<Object> get props => [];
}

class FlowMeterError extends FlowMeterStatus {
  final String error;

  const FlowMeterError(this.error);

  @override
  List<Object> get props => [error];
}


class FlowMeterSuccess extends FlowMeterStatus {
  final WellFlowMeterEntity? wellFlowMeterEntity;


  const FlowMeterSuccess({ this.wellFlowMeterEntity});

  // // متد copyWith برای اینکه وقتی یکی آمد، قبلی پاک نشود
  // FlowMeterSuccess copyWith({
  //   int? newStatus,
  // }) {
  //   return FlowMeterSuccess(
  //     status: newStatus ?? status,
  //   );
  // }

  @override
  // TODO: implement props
  List<Object?> get props =>[wellFlowMeterEntity];
}
