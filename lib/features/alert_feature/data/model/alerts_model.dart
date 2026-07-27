/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import 'package:mahaliii/features/alert_feature/data/model/alert_meta_model.dart';

import '../../domain/entity/alert_data_entity.dart';
import '../../domain/entity/alert_meta_entity.dart';
import '../../domain/entity/alerts_entity.dart';
import 'alert_data_model.dart';

class AlertsModel extends AlertsEntity {
  AlertsModel({

    List<AlertDataEntity>? data,
    required AlertMetaEntity meta,



  }) : super(data,meta);

  factory AlertsModel.fromJson(dynamic json) {

    return AlertsModel(
       data: AlertDataModel.parseList(json["data"]),
       meta: AlertMetaModel.fromJson(json["meta"]),

    );
  }


}
