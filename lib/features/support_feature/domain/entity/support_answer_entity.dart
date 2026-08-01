
import 'package:mahaliii/features/alert_feature/domain/entity/alert_meta_entity.dart';
import 'package:mahaliii/features/report_feature/domain/entity/capacity_list_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_answer_list_entity.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_data_entity.dart';

class SupportAnswerEntity {
  // "payvast": "file-1785158272521-623217533.jpg",

   final List<SupportDataEntity>? support;
   final List<SupportAnswerListEntity>? list;
   final String? user;

    SupportAnswerEntity( this.support,this.list,this.user);
}
