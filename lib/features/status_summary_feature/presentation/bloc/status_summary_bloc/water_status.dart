
import 'package:equatable/equatable.dart';

import '../../../domain/entity/water_entity.dart';

abstract class WaterStatus extends Equatable {
  const WaterStatus();
}

class WaterLoading extends WaterStatus {
  @override
  List<Object> get props => [];
}

class WaterError extends WaterStatus {
  final String error;

  const WaterError(this.error);

  @override
  List<Object> get props => [error];
}

class WaterSuccess extends WaterStatus {
  final WaterEntity? waterData;

  const WaterSuccess({this.waterData});

  // متد copyWith برای اینکه وقتی یکی آمد، قبلی پاک نشود
  WaterSuccess copyWith({
    WaterEntity? waterData,
  }) {
    return WaterSuccess(
      waterData: waterData ?? this.waterData,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>[waterData];
}
