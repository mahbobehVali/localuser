import 'package:equatable/equatable.dart';

abstract class SupportCloseStatus extends Equatable {
  const SupportCloseStatus();
}

class SupportCloseInitial extends SupportCloseStatus {
  @override
  List<Object> get props => [];
}

class SupportCloseLoading extends SupportCloseStatus {
  @override
  List<Object> get props => [];
}

class SupportCloseAgainLoading extends SupportCloseStatus {
  @override
  List<Object> get props => [];
}

class SupportCloseEmpty extends SupportCloseStatus {
  @override
  List<Object> get props => [];
}

class SupportCloseError extends SupportCloseStatus {
  final String error;

  const SupportCloseError(this.error);

  @override
  List<Object> get props => [error];
}

class SupportCloseSuccess extends SupportCloseStatus {

 const SupportCloseSuccess();

  @override
  List<Object> get props => [];
}
