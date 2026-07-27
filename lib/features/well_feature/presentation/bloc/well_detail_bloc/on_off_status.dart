
import 'package:equatable/equatable.dart';


abstract class OnOffStatus extends Equatable {
  const OnOffStatus();
}

class OnOffLoading extends OnOffStatus {
  @override
  List<Object> get props => [];
}

class OnOffInitial extends OnOffStatus {
  @override
  List<Object> get props => [];
}

class OnOffError extends OnOffStatus {
  final String error;

  const OnOffError(this.error);

  @override
  List<Object> get props => [error];
}

class OnOffSuccess extends OnOffStatus {
  final int status;

 const OnOffSuccess(this.status);


  @override
  // TODO: implement props
  List<Object?> get props =>[status];
}
