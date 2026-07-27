import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_work_entity.dart';

abstract class ReportCommandStatus extends Equatable {
  const ReportCommandStatus();
}

class ReportCommandInitial extends  ReportCommandStatus {
  @override
  List<Object> get props => [];
}

class ReportCommandLoading extends ReportCommandStatus {
  @override
  List<Object> get props => [];
}

class ReportCommandError extends ReportCommandStatus {
  final String error;

  const ReportCommandError(this.error);

  @override
  List<Object> get props => [error];
}

class ReportCommandSuccess extends ReportCommandStatus {
  final WellWorkEntity reportFlowMeter;

  const ReportCommandSuccess(this.reportFlowMeter);

  @override
  List<Object> get props => [reportFlowMeter];
}
