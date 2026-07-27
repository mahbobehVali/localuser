
import '../../domain/entity/university_list_entity.dart';

class UniversityListModel extends UniversityListEntity {
  UniversityListModel({
    int? id,
    String? name,
  }) : super(id,name);

  factory UniversityListModel.fromJson(dynamic json) {
    return UniversityListModel(
      id: json["id"],
        name: json["name"]
    );
  }
}
