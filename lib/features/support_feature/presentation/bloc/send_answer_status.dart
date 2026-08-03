import 'package:equatable/equatable.dart';
abstract class SendAnswerStatus extends Equatable {
  const SendAnswerStatus();
}

class SendAnswerInitial extends SendAnswerStatus {
  @override
  List<Object> get props => [];
}

class SendAnswerLoading extends SendAnswerStatus {
  @override
  List<Object> get props => [];
}

class SendAnswerAgainLoading extends SendAnswerStatus {
  @override
  List<Object> get props => [];
}

class SendAnswerEmpty extends SendAnswerStatus {
  @override
  List<Object> get props => [];
}

class SendAnswerError extends SendAnswerStatus {
  final String error;

  const SendAnswerError(this.error);

  @override
  List<Object> get props => [error];
}

class SendAnswerSuccess extends SendAnswerStatus {

 const SendAnswerSuccess();

  @override
  List<Object> get props => [];
}
