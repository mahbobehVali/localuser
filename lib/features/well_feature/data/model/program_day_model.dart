import 'package:mahaliii/features/well_feature/data/model/program_period_model.dart';
import 'package:mahaliii/features/well_feature/domain/entity/program_day_entity.dart';
import 'package:mahaliii/features/well_feature/domain/entity/program_period_entity.dart';

class ProgramDayModel extends ProgramDayEntity {
  ProgramDayModel({

    final String? dayName,
    final List<ProgramPeriodEntity>? periods,

  }) : super(dayName,periods);

  factory ProgramDayModel.fromJson(dynamic json) {
    return ProgramDayModel(
      dayName: json["dayName"],
      periods: ProgramPeriodModel.parseList(json["periods"]),

    );
  }

}


