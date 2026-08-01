import 'package:collection/collection.dart'; // 1. این پکیج را ایمپورت کنید
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_entity.dart';
abstract class SendSupportStatus extends Equatable {
  const SendSupportStatus();
}

class SendSupportInitial extends SendSupportStatus {
  @override
  List<Object> get props => [];
}

class SendSupportLoading extends SendSupportStatus {
  @override
  List<Object> get props => [];
}

class SendSupportEmpty extends SendSupportStatus {
  @override
  List<Object> get props => [];
}

class SendSupportError extends SendSupportStatus {
  final String error;

  const SendSupportError(this.error);

  @override
  List<Object> get props => [error];
}

class SendSupportSuccess extends SendSupportStatus {

 const SendSupportSuccess();

  @override
  List<Object> get props => [];
}
