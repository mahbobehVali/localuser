import '../../domain/entity/area_entity.dart';

class AreaModel extends AreaEntity {
  AreaModel({
     String? name,
    int? regionId,
    int? id,
  }) : super(name, regionId, id);

  factory AreaModel.fromJson(dynamic json) {
    return AreaModel(
      name: json["name"],
      regionId: json["region_id"],
      id: json["id"],
    );
  }
}
