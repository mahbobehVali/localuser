import 'package:mahaliii/features/well_feature/data/model/program_day_model.dart';
import 'package:mahaliii/features/well_feature/domain/entity/program_day_entity.dart';

List<ProgramDayEntity> parseWeeklySchedule(List<dynamic> jsonResponse) {
    if (jsonResponse.isEmpty) return [];

    // دسترسی به اولین آبجکت درون لیست اصلی
    Map<String, dynamic> weeklyData = jsonResponse[0];
    List<ProgramDayEntity> weeklySchedule = [];

    // پیمایش کلیدهای "0" تا "6"
    weeklyData.forEach((key, value) {
        weeklySchedule.add(ProgramDayModel.fromJson(value));
    });

    return weeklySchedule;
}