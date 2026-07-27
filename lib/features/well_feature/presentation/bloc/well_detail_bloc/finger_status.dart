
import 'package:equatable/equatable.dart';

abstract class FingerStatus extends Equatable {
  const FingerStatus();
}

class FingerLoading extends FingerStatus {
  @override
  List<Object> get props => [];
}

class FingerRequestAccepted extends FingerStatus {
  final int status;

  const FingerRequestAccepted(this.status);

  @override
  List<Object> get props => [status];
}
class FingerRequestFailed extends FingerStatus {
  final String error;


  const FingerRequestFailed(this.error);

  @override
  List<Object> get props => [error];
}

class FingerInitial extends FingerStatus {
  @override
  List<Object> get props => [];
}

class FingerError extends FingerStatus {
  final String error;

  const FingerError(this.error);

  @override
  List<Object> get props => [error];
}

class FingerSuccess extends FingerStatus {
  final int status;
  final int userLocalID;

  const FingerSuccess({required this.status,required this.userLocalID});

  // // متد copyWith برای اینکه وقتی یکی آمد، قبلی پاک نشود
  // FingerSuccess copyWith({
  //   int? newStatus,
  // }) {
  //   return FingerSuccess(
  //     status: newStatus ?? status,
  //   );
  // }

  @override
  // TODO: implement props
  List<Object?> get props =>[status,userLocalID];
}
