import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/report_feature/domain/entity/capacity_entity.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_flowmeter_entity.dart';

abstract class ReportFlowMeterStatus extends Equatable {
  const ReportFlowMeterStatus();
}

class ReportFlowMeterInitial extends  ReportFlowMeterStatus {
  @override
  List<Object> get props => [];
}

class ReportFlowMeterLoading extends ReportFlowMeterStatus {
  @override
  List<Object> get props => [];
}

class ReportFlowMeterError extends ReportFlowMeterStatus {
  final String error;

  const ReportFlowMeterError(this.error);

  @override
  List<Object> get props => [error];
}

class ReportFlowMeterSuccess extends ReportFlowMeterStatus {
  final WellFlowMeterEntity reportFlowMeter;
  final CapacityEntity capacityEntity;

  const ReportFlowMeterSuccess(this.reportFlowMeter,this.capacityEntity);

  @override
  List<Object> get props => [reportFlowMeter,capacityEntity];
}
