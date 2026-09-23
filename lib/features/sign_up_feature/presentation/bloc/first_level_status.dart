



import 'package:equatable/equatable.dart';

abstract class FirstLevelSendStatus extends Equatable {
  const FirstLevelSendStatus();
}

class FirstLevelInitial extends FirstLevelSendStatus {
  @override
  List<Object> get props => [];
}

class FirstLevelLoading extends FirstLevelSendStatus {
  @override
  List<Object> get props => [];
}

class FirstLevelError extends FirstLevelSendStatus {
  final String error;

  const FirstLevelError(this.error);

  @override
  List<Object> get props => [error];
}

class FirstLevelSuccess extends FirstLevelSendStatus {
  // final int serverId;

  const  FirstLevelSuccess();

  @override
  List<Object> get props => [];
}
