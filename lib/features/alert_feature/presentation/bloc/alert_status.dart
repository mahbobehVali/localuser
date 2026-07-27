
import 'package:equatable/equatable.dart';

import '../../domain/entity/alerts_entity.dart';

sealed class AlertStatus extends Equatable {
  const AlertStatus();
}

final class AlertInitial extends AlertStatus {
  @override
  List<Object> get props => [];
}
final class AlertLoading extends AlertStatus {
  @override
  List<Object> get props => [];
}
final class AlertEmpty extends AlertStatus {
  @override
  List<Object> get props => [];
}
final class AlertSuccess extends AlertStatus {
  final AlertsEntity alertsEntity;

  const AlertSuccess(this.alertsEntity);

  @override
  List<Object> get props => [alertsEntity];
}
final class AlertError extends AlertStatus {
  final String error;
  const AlertError(this.error);

  @override
  List<Object> get props => [error];

}

