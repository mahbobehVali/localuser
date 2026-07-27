import 'package:mahaliii/features/well_feature/domain/entity/alert_count_by_date_entity.dart';

import 'alert_count_by_type_entity.dart';

class AlertCountEntity {
    final List<AlertCountByDateEntity>? alertCountByDate;
    final int? totalCount;
    final List<AlertCountByTypeEntity>? countByType;

    AlertCountEntity( this.alertCountByDate,this.totalCount,this.countByType);
}
