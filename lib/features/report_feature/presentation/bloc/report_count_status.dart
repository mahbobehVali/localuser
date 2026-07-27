import 'package:equatable/equatable.dart';

import '../../../well_feature/domain/entity/alert_count_entity.dart';

abstract class ReportCountStatus extends Equatable {
  const ReportCountStatus();
}

class ReportCountInitial extends ReportCountStatus {
  @override
  List<Object> get props => [];
}

class ReportCountLoading extends ReportCountStatus {
  @override
  List<Object> get props => [];
}

class ReportCountError extends ReportCountStatus {
  final String error;

  const ReportCountError(this.error);

  @override
  List<Object> get props => [error];
}

class ReportCountSuccess extends ReportCountStatus {
  final AlertCountEntity alertCountEntity;

  const ReportCountSuccess(this.alertCountEntity);

  @override
  List<Object> get props => [alertCountEntity];
}
