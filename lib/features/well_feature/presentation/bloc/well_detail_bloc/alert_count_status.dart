
import 'package:equatable/equatable.dart';

import '../../../domain/entity/alert_count_entity.dart';


abstract class AlertCountStatus extends Equatable {
  const AlertCountStatus();
}

class AlertCountLoading extends AlertCountStatus {
  @override
  List<Object> get props => [];
}

class AlertCountError extends AlertCountStatus {
  final String error;

  const AlertCountError(this.error);

  @override
  List<Object> get props => [error];
}

class AlertCountSuccess extends AlertCountStatus {
  final AlertCountEntity alertCountEntity;

  const AlertCountSuccess(this.alertCountEntity);


  @override
  // TODO: implement props
  List<Object?> get props =>[alertCountEntity];
}
