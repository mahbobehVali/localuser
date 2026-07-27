
import '../../domain/entity/water_entity.dart';

class WaterModel extends WaterEntity {
  WaterModel({
       num? total,
       num? today,
       num? weekly,
       num? monthly,
  }) : super(total, today, weekly,monthly);

  factory WaterModel.fromJson(dynamic json) {
    return WaterModel(
      total: json["total"],
      today: json["today"],
      weekly: json["weekly"],
      monthly: json["monthly"],
    );
  }
}
