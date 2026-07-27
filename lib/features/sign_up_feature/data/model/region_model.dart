import '../../domain/entity/region_entity.dart';

class RegionModel extends RegionEntity {
  RegionModel({
     String? name,
    int? id,
  }) : super(name, id);

  factory RegionModel.fromJson(dynamic json) {
    return RegionModel(
      name: json["name"],
      id: json["id"],
    );
  }
}
