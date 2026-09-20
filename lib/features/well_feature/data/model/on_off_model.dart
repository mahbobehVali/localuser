
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_by_date_entity.dart';

import '../../domain/entity/on_off_entity.dart';

class OnOffModel extends OnOffEntity {
  OnOffModel({
     int? status,
     int? id,
     int? wellId,
     int? deviceId,
     int? area_id,
     String? name,


  }) : super(status, id,wellId,deviceId,area_id,name);

  factory OnOffModel.fromJson(dynamic json) {

    return OnOffModel(
      status: json["status"],
      id: json["id"],
      wellId: json["well_id"],
      deviceId: json["device_id"],
      area_id: json["area_id"],
      name: json["name"],


    );
  }


}



