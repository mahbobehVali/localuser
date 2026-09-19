
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/well_feature/domain/entity/on_off_entity.dart';


abstract class OnOffWrapperStatus extends Equatable {
  const OnOffWrapperStatus();
}

class OnOffWrapperLoading extends OnOffWrapperStatus {
  @override
  List<Object> get props => [];
}

class OnOffWrapperInitial extends OnOffWrapperStatus {
  @override
  List<Object> get props => [];
}

class OnOffWrapperError extends OnOffWrapperStatus {
  final String error;

  const OnOffWrapperError(this.error);

  @override
  List<Object> get props => [error];
}

class OnOffWrapperSuccess extends OnOffWrapperStatus {
  final OnOffEntity offEntity;

 const OnOffWrapperSuccess(this.offEntity);


  @override
  // TODO: implement props
  List<Object?> get props =>[offEntity];
}
