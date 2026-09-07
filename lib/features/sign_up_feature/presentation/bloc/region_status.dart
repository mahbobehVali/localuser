
import 'package:equatable/equatable.dart';

import '../../domain/entity/region_entity.dart';

abstract class RegionStatus extends Equatable {
  const RegionStatus();
}

class RegionLoading extends RegionStatus {
  @override
  List<Object> get props => [];
}
class RegionInitial extends RegionStatus {
  @override
  List<Object> get props => [];
}

class RegionError extends RegionStatus {
  final String error;

  const RegionError(this.error);

  @override
  List<Object> get props => [error];
}

class RegionSuccess extends RegionStatus {
  final List<RegionEntity> regionEntity;

  const RegionSuccess(this.regionEntity);

  @override
  List<Object> get props => [regionEntity];
}
