import 'package:mahaliii/features/status_summary_feature/domain/entity/total_type_count_entity.dart';

import 'last_activity_dates_entity.dart';

class LastActivityDataEntity {
  int? id;
  String? name;
  TotalTypesCountEntity? totalTypesCount;
  List<LastActivityDatesEntity>? dates;

  LastActivityDataEntity( this.id, this.name, this.totalTypesCount,this.dates);
}
