
import 'package:mahaliii/features/alert_feature/domain/entity/alert_meta_entity.dart';
import 'package:mahaliii/features/report_feature/domain/entity/capacity_list_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_data_entity.dart';

class SupportEntity {
  // "payvast": "file-1785158272521-623217533.jpg",

   final List<SupportDataEntity>? data;
   final AlertMetaEntity? meta;

    SupportEntity( this.data,this.meta);
}
