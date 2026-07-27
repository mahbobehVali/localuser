import 'alert_data_entity.dart';
import 'alert_meta_entity.dart';

class AlertsEntity {
  List<AlertDataEntity>? data;
  AlertMetaEntity meta;



  AlertsEntity( this.data,this.meta);
}
