import 'package:equatable/equatable.dart';

import '../../domain/entity/support_answer_entity.dart';
abstract class SupportAnswersStatus extends Equatable {
  const SupportAnswersStatus();
}

class SupportAnswersInitial extends SupportAnswersStatus {
  @override
  List<Object> get props => [];
}

class SupportAnswersLoading extends SupportAnswersStatus {
  @override
  List<Object> get props => [];
}

class SupportAnswersEmpty extends SupportAnswersStatus {
  @override
  List<Object> get props => [];
}

class SupportAnswersError extends SupportAnswersStatus {
  final String error;

  const SupportAnswersError(this.error);

  @override
  List<Object> get props => [error];
}

class SupportAnswersSuccess extends SupportAnswersStatus {
 final SupportAnswerEntity supportAnswerEntity;

 const SupportAnswersSuccess(this.supportAnswerEntity);

  @override
  List<Object> get props => [supportAnswerEntity];
}
