import 'package:collection/collection.dart'; // 1. این پکیج را ایمپورت کنید
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_entity.dart';
abstract class SupportStatus extends Equatable {
  const SupportStatus();
}

class SupportInitial extends SupportStatus {
  @override
  List<Object> get props => [];
}

class SupportLoading extends SupportStatus {
  @override
  List<Object> get props => [];
}

class SupportEmpty extends SupportStatus {
  @override
  List<Object> get props => [];
}

class SupportError extends SupportStatus {
  final String error;

  const SupportError(this.error);

  @override
  List<Object> get props => [error];
}

class SupportSuccess extends SupportStatus {
 final SupportEntity supportEntity;

 const SupportSuccess(this.supportEntity);

  @override
  List<Object> get props => [supportEntity];
}
