import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_flowmeter_entity.dart';

import '../../domain/entity/capacity_entity.dart';

abstract class ReportDetailFlowMeterStatus extends Equatable {
  const ReportDetailFlowMeterStatus();
}

class ReportDetailFlowMeterInitial extends  ReportDetailFlowMeterStatus {
  @override
  List<Object> get props => [];
}

class ReportDetailFlowMeterLoading extends ReportDetailFlowMeterStatus {
  @override
  List<Object> get props => [];
}

class ReportDetailFlowMeterError extends ReportDetailFlowMeterStatus {
  final String error;

  const ReportDetailFlowMeterError(this.error);

  @override
  List<Object> get props => [error];
}

class ReportDetailFlowMeterSuccess extends ReportDetailFlowMeterStatus {
  final WellFlowMeterEntity wellReportDetailFlowMeter;
  final CapacityEntity capacityEntity;

  const ReportDetailFlowMeterSuccess(this.wellReportDetailFlowMeter,this.capacityEntity);

  @override
  List<Object> get props => [wellReportDetailFlowMeter,capacityEntity];
}
