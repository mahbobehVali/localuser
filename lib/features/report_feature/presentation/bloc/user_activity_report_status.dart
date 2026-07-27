import 'package:equatable/equatable.dart';

import '../../../status_summary_feature/domain/entity/last_activity_entity.dart'; // 1. این پکیج را ایمپورت کنید
abstract class  UserActivityReportStatus extends Equatable {
  const  UserActivityReportStatus();
}

class  UserActivityReportInitial extends  UserActivityReportStatus {
  @override
  List<Object> get props => [];
}

class  UserActivityReportLoading extends  UserActivityReportStatus {
  @override
  List<Object> get props => [];
}

class  UserActivityReportEmpty extends  UserActivityReportStatus {
  @override
  List<Object> get props => [];
}


class  UserActivityReportError extends  UserActivityReportStatus {
  final String error;

  const  UserActivityReportError(this.error);

  @override
  List<Object> get props => [error];
}

class  UserActivityReportSuccess extends  UserActivityReportStatus {
  final LastActivityEntity lastActivityEntity;
   const UserActivityReportSuccess(this.lastActivityEntity);

  @override
  List<Object> get props => [lastActivityEntity];
}
