
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_by_date_entity.dart';

import '../../domain/entity/on_off_entity.dart';

class OnOffModel extends OnOffEntity {
  OnOffModel({
     int? status,
     int? id,
     int? well_id,
     int? devic_id,
     int? area_id,
     String? name,


  }) : super(status, id,well_id,devic_id,area_id,name);

  factory OnOffModel.fromJson(dynamic json) {

    return OnOffModel(
      status: json["status"],
      id: json["id"],
      well_id: json["well_id"],
      devic_id: json["devic_id"],
      area_id: json["area_id"],
      name: json["name"],


    );
  }


}



