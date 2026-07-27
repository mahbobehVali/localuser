
import 'package:equatable/equatable.dart';


abstract class CreateTimeStatus extends Equatable {
  const CreateTimeStatus();
}

class CreateTimeLoading extends CreateTimeStatus {
  @override
  List<Object> get props => [];
}

class CreateTimeInitial extends CreateTimeStatus {
  @override
  List<Object> get props => [];
}

class CreateTimeError extends CreateTimeStatus {
  final String error;
  const CreateTimeError(this.error);

  @override
  List<Object> get props => [error];
}

class CreateTimeSuccess extends CreateTimeStatus {
  final int status;
  const CreateTimeSuccess(this.status);


  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
