
import 'package:mahaliii/features/support_feature/domain/entity/support_answer_list_entity.dart';

import '../../domain/entity/support_data_entity.dart';

class SupportAnswerListModel extends SupportAnswerListEntity {
  SupportAnswerListModel({

    final int? id,
    final String? description,
    final String? date,
    final String? clock,
    final dynamic payvast,
    final int? to,
    final String? name,

  }) : super( id,description,date,clock,payvast,to,name);

  factory SupportAnswerListModel.fromJson(dynamic json) {

    return SupportAnswerListModel(
      id: json["id"],

      description: json["description"],
      date: json["date"],
      clock: json["clock"],
      payvast: json["payvast"],
      to: json["to"],
      name: json["name"],

    );
  }

  static List<SupportAnswerListEntity> parseList(List<dynamic> jsonArray) {
    List<SupportAnswerListEntity> data = [];

    for (var element in jsonArray) {
      data.add(SupportAnswerListModel.fromJson(element));
    }

    return data;
  }

}



