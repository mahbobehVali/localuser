import 'package:equatable/equatable.dart';

abstract class SendSmsStatus extends Equatable {
  const SendSmsStatus();
}

class SendSmsInitial extends SendSmsStatus {
  @override
  List<Object> get props => [];
}

class SendSmsLoading extends SendSmsStatus {
  @override
  List<Object> get props => [];
}

class SendSmsError extends SendSmsStatus {
  final String error;

  const SendSmsError(this.error);

  @override
  List<Object> get props => [error];
}

class SendSmsSuccess extends SendSmsStatus {
  final int serverId;

 const SendSmsSuccess(this.serverId);

  @override
  List<Object> get props => [serverId];
}
