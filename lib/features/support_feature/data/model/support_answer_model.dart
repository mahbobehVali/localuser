
import 'package:mahaliii/features/alert_feature/data/model/alert_meta_model.dart';
import 'package:mahaliii/features/support_feature/data/model/support_answer_list_model.dart';
import 'package:mahaliii/features/support_feature/data/model/support_data_model.dart';

import '../../../alert_feature/domain/entity/alert_meta_entity.dart';
import '../../domain/entity/support_answer_entity.dart';
import '../../domain/entity/support_answer_list_entity.dart';
import '../../domain/entity/support_data_entity.dart';
import '../../domain/entity/support_entity.dart';

class SupportAnswerModel extends SupportAnswerEntity {
  SupportAnswerModel({
    final List<SupportDataEntity>? support,
    final List<SupportAnswerListEntity>? list,
    final String? user,

  }) : super( support,list,user);

  factory SupportAnswerModel.fromJson(dynamic json) {

    return SupportAnswerModel(
      user: json["user"],
      support: SupportDataModel.parseList(json["support"]),
      list: SupportAnswerListModel.parseList(json["list"]??[]),


    );
  }

}



