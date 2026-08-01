
import 'package:mahaliii/features/alert_feature/data/model/alert_meta_model.dart';
import 'package:mahaliii/features/support_feature/data/model/support_data_model.dart';

import '../../../alert_feature/domain/entity/alert_meta_entity.dart';
import '../../domain/entity/support_data_entity.dart';
import '../../domain/entity/support_entity.dart';

class SupportModel extends SupportEntity {
  SupportModel({
    final List<SupportDataEntity>? data,
    final AlertMetaEntity? meta,

  }) : super( data,meta);

  factory SupportModel.fromJson(dynamic json) {

    return SupportModel(
      meta: AlertMetaModel.fromJson(json["meta"]),
      data: SupportDataModel.parseList(json["data"]),
    

    );
  }

}



