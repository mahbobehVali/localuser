/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import '../../domain/entity/user_information_entity.dart';

class UserInformationModel extends UserInformationEntity {
  UserInformationModel({
    int? id,
    String? mobile,
    String? nationalCode,
    int? role,
    String? name,
    int? regionId,
    int? areaId,
    String? areaName,
    String? regionName,
    int? smsType,

  }) : super(id, mobile,nationalCode,role, name, regionId, areaId, areaName, regionName,smsType);

  factory UserInformationModel.fromJson(dynamic json) {

    return UserInformationModel(
       id: json["id"],
       mobile: json["mobile"],
       nationalCode: json["national_code"],
       role: json["role"],
       name: json["name"],
       regionId: json["region_id"],
      areaId: json["area_id"],
       areaName: json["area_name"],
       regionName: json["region_name"],
       smsType: json["sms_type"],

    );
  }
}
