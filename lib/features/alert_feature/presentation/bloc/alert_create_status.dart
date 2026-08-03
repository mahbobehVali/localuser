
import 'package:equatable/equatable.dart';

sealed class AlertCreateStatus extends Equatable {
  const AlertCreateStatus();
}

final class AlertCreateInitial extends AlertCreateStatus {
  @override
  List<Object> get props => [];
}
final class AlertCreateLoading extends AlertCreateStatus {
  @override
  List<Object> get props => [];
}
final class AlertCreateEmpty extends AlertCreateStatus {
  @override
  List<Object> get props => [];
}
final class AlertCreateSuccess extends AlertCreateStatus {

  const AlertCreateSuccess();

  @override
  List<Object> get props => [];
}
final class AlertCreateError extends AlertCreateStatus {
  final String error;
  const AlertCreateError(this.error);

  @override
  List<Object> get props => [error];

}

