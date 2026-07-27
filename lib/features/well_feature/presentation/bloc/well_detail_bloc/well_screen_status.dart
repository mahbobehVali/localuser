
import 'package:equatable/equatable.dart';



abstract class WellScreenStatus extends Equatable {
  const WellScreenStatus();
}

class WellScreenInitial extends WellScreenStatus {
  @override
  List<Object> get props => [];
}

class WellScreenError extends WellScreenStatus {
  final String error;

  const WellScreenError(this.error);

  @override
  List<Object> get props => [error];
}

class WellScreenSuccess extends WellScreenStatus {

  const WellScreenSuccess();


  @override
  // TODO: implement props
  List<Object?> get props =>[];
}
