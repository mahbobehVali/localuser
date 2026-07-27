

import 'package:mahaliii/features/report_feature/data/model/capacity_list_model.dart';
import 'package:mahaliii/features/report_feature/domain/entity/capacity_list_entity.dart';

import '../../domain/entity/capacity_entity.dart';

class CapacityModel extends CapacityEntity {
  CapacityModel({
    final List<CapacityListEntity>? capacityListEntity,
    final int? totalCapacity,
    final int? totalDisconnectCapacity,


  }) : super(capacityListEntity, totalCapacity,totalDisconnectCapacity);

  factory CapacityModel.fromJson(dynamic json) {

    return CapacityModel(
      capacityListEntity: CapacityListModel.parseList(json["list"]),
      totalCapacity: json["totalCapacity"],
      totalDisconnectCapacity: json["totalDisconnectCapacity"],

    );
  }

}



