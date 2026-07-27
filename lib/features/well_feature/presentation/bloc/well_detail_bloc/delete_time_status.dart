
import 'package:equatable/equatable.dart';


abstract class DeleteTimeStatus extends Equatable {
  const DeleteTimeStatus();
}

class DeleteTimeLoading extends DeleteTimeStatus {
  @override
  List<Object> get props => [];
}

class DeleteTimeInitial extends DeleteTimeStatus {
  @override
  List<Object> get props => [];
}

class DeleteTimeError extends DeleteTimeStatus {
  final String error;
  const DeleteTimeError(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteTimeSuccess extends DeleteTimeStatus {
  final int status;
  const DeleteTimeSuccess(this.status);


  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
