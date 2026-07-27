
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/summary_flowmeter_entity.dart';


abstract class SummaryFlowMeterStatus extends Equatable {
  const SummaryFlowMeterStatus();
}

class SummaryFlowMeterLoading extends SummaryFlowMeterStatus {
  @override
  List<Object> get props => [];
}
class SummaryFlowMeterInitial extends SummaryFlowMeterStatus {
  @override
  List<Object> get props => [];
}

class SummaryFlowMeterError extends SummaryFlowMeterStatus {
  final String error;

  const SummaryFlowMeterError(this.error);

  @override
  List<Object> get props => [error];
}

class SummaryFlowMeterSuccess extends SummaryFlowMeterStatus {
  final SummaryFlowMeterEntity flowMeterEntity;


  const SummaryFlowMeterSuccess(this.flowMeterEntity);

  @override
  List<Object> get props => [flowMeterEntity];
}
