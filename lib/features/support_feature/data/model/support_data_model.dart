
import '../../domain/entity/support_data_entity.dart';

class SupportDataModel extends SupportDataEntity {
  SupportDataModel({
    final int? id,
    final int? part,
    final int? status,
    final String? subject,
    final String? description,
    final String? date,
    final String? clock,
    final String? payvast,

  }) : super( id,part,status,subject,description,date,clock,payvast);

  factory SupportDataModel.fromJson(dynamic json) {

    return SupportDataModel(
      id: json["id"],
      part: json["part"],
      status: json["status"],
      subject: json["subject"],
      description: json["description"],
      date: json["date"],
      clock: json["clock"],
      payvast: json["payvast"],

    );
  }

  static List<SupportDataEntity> parseList(List<dynamic> jsonArray) {
    List<SupportDataEntity> data = [];

    for (var element in jsonArray) {
      data.add(SupportDataModel.fromJson(element));
    }

    return data;
  }

}



