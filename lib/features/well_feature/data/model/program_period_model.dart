import 'package:mahaliii/features/well_feature/domain/entity/program_period_entity.dart';


class ProgramPeriodModel extends ProgramPeriodEntity {
  ProgramPeriodModel({

    final String? startTime,
    final String? endTime,
    final int? userLocalID,
    final int? id,
    final int? own,
  }) : super(startTime,endTime,userLocalID,id,own);

  factory ProgramPeriodModel.fromJson(dynamic json) {
    return ProgramPeriodModel(
      startTime: json["startTime"],
      endTime: json["endTime"],
      userLocalID: json["userLocalID"],
      id: json["id"],
      own: json["own"],

    );
  }

  static List<ProgramPeriodEntity> parseList(List<dynamic> jsonArray) {
    List<ProgramPeriodEntity> data = [];
    for (var element in jsonArray) {
      data.add(ProgramPeriodModel.fromJson(element));
    }
    return data;
  }
}


