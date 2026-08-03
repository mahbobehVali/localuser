import 'package:equatable/equatable.dart';
abstract class SendSupportStatus extends Equatable {
  const SendSupportStatus();
}

class SendSupportInitial extends SendSupportStatus {
  @override
  List<Object> get props => [];
}

class SendSupportLoading extends SendSupportStatus {
  @override
  List<Object> get props => [];
}

class SendSupportEmpty extends SendSupportStatus {
  @override
  List<Object> get props => [];
}

class SendSupportError extends SendSupportStatus {
  final String error;

  const SendSupportError(this.error);

  @override
  List<Object> get props => [error];
}

class SendSupportSuccess extends SendSupportStatus {

 const SendSupportSuccess();

  @override
  List<Object> get props => [];
}
