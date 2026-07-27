import 'package:collection/collection.dart'; // 1. این پکیج را ایمپورت کنید
import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_entity.dart';
abstract class WellReportStatus extends Equatable {
  const WellReportStatus();
}

class WellReportInitial extends WellReportStatus {
  @override
  List<Object> get props => [];
}

class WellReportLoading extends WellReportStatus {
  @override
  List<Object> get props => [];
}

class WellReportError extends WellReportStatus {
  final String error;

  const WellReportError(this.error);

  @override
  List<Object> get props => [error];
}

class WellReportSuccess extends WellReportStatus {
 final List<WellsEntity> wellsEntity;

 const WellReportSuccess(this.wellsEntity);

  @override
  List<Object> get props => [ListEquality().hash(wellsEntity)];
}
