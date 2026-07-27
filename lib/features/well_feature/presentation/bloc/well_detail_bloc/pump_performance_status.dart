
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_entity.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_flowmeter_entity.dart';

import '../../../domain/entity/well_work_entity.dart';


abstract class WellPerformanceStatus extends Equatable {
  const WellPerformanceStatus();
}

class WellPerformanceLoading extends WellPerformanceStatus {
  @override
  List<Object> get props => [];
}

class WellPerformanceError extends WellPerformanceStatus {
  final String error;

  const WellPerformanceError(this.error);

  @override
  List<Object> get props => [error];
}

class WellPerformanceSuccess extends WellPerformanceStatus {
  final WellWorkEntity currentWellWorkEntity;
  final WellFlowMeterEntity wellFlowMeterEntity;
  final AlertCountEntity alertCountEntity;
  const WellPerformanceSuccess({required this.currentWellWorkEntity,
    required this.wellFlowMeterEntity,
  required this.alertCountEntity});

  @override
  // TODO: implement props
  List<Object?> get props =>[currentWellWorkEntity,wellFlowMeterEntity];
}
