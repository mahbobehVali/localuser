/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import '../../domain/entity/alert_meta_entity.dart';

class AlertMetaModel extends AlertMetaEntity {
  AlertMetaModel({

    int? page,
    int? limit,
    int? total,
    int? lastPage,


  }) : super(page,limit,total,lastPage);

  factory AlertMetaModel.fromJson(dynamic json) {

    return AlertMetaModel(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      lastPage: json["last_page"],

    );
  }

}
