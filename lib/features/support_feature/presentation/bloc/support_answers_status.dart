import 'package:collection/collection.dart'; // 1. این پکیج را ایمپورت کنید
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_entity.dart';

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
