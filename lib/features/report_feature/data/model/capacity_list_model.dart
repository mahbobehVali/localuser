

import 'package:mahaliii/features/report_feature/domain/entity/capacity_list_entity.dart';


class CapacityListModel extends CapacityListEntity {
  CapacityListModel({
    final int? id,
    final String? name,
    final int? capacity,
    final int? disconnectCapacity,


  }) : super(id, name,capacity,disconnectCapacity);

  factory CapacityListModel.fromJson(dynamic json) {

    return CapacityListModel(
      id: json["id"],
      name: json["name"],
      capacity: json["capacity"],
      disconnectCapacity: json["disconnect_capacity"],

    );
  }

  static List<CapacityListEntity> parseList(List<dynamic> jsonArray) {
    List<CapacityListEntity> data = [];

    for (var element in jsonArray) {
      data.add(CapacityListModel.fromJson(element));
    }

    return data;
  }


}



