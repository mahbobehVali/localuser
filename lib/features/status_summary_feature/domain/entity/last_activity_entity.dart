import 'package:mahaliii/features/status_summary_feature/domain/entity/last_activity_data_entity.dart';

class LastActivityEntity {
  int? total;
  int? page;
  int? limit;
  int? lastPage;
  List<LastActivityDataEntity>? data;

  LastActivityEntity( this.total, this.page, this.limit,this.lastPage,this.data);
}
