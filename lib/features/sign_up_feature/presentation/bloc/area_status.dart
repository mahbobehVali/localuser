
import 'package:equatable/equatable.dart';

import '../../domain/entity/area_entity.dart';


abstract class AreaStatus extends Equatable {
  const AreaStatus();
}

class AreaLoading extends AreaStatus {
  @override
  List<Object> get props => [];
}

class AreaError extends AreaStatus {
  final String error;

  const AreaError(this.error);

  @override
  List<Object> get props => [error];
}

class AreaSuccess extends AreaStatus {
  final List<AreaEntity> areaEntity;

  const AreaSuccess(this.areaEntity);

  @override
  List<Object> get props => [areaEntity];
}
