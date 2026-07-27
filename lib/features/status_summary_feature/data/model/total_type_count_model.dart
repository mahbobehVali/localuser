import '../../domain/entity/total_type_count_entity.dart';


class TotalTypesCountModel extends TotalTypesCountEntity {
  TotalTypesCountModel({
    int? manual,
    int? web,
    int? schedule,
    int? smart,
    int? alert,
  }) : super(manual,web,schedule,smart,alert);

  factory TotalTypesCountModel.fromJson(dynamic json) {

    return TotalTypesCountModel(
      manual: json["manual"],
      web: json["web"],
      schedule: json["schedule"],
      smart: json["smart"],
      alert: json["alert"],


    );
  }
}
