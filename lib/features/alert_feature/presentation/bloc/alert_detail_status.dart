
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_detail_entity.dart';

import '../../domain/entity/alerts_entity.dart';

sealed class AlertDetailStatus extends Equatable {
  const AlertDetailStatus();
}

final class AlertDetailInitial extends AlertDetailStatus {
  @override
  List<Object> get props => [];
}
final class AlertDetailLoading extends AlertDetailStatus {
  @override
  List<Object> get props => [];
}
final class AlertDetailEmpty extends AlertDetailStatus {
  @override
  List<Object> get props => [];
}
final class AlertDetailSuccess extends AlertDetailStatus {
  final List<AlertDetailEntity> alertDetailEntity;

  const AlertDetailSuccess(this.alertDetailEntity);

  @override
  List<Object> get props => [alertDetailEntity];
}
final class AlertDetailError extends AlertDetailStatus {
  final String error;
  const AlertDetailError(this.error);

  @override
  List<Object> get props => [error];

}

