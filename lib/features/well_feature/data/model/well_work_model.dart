import 'package:mahaliii/features/well_feature/data/model/well_work_list_model.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_work_entity.dart';

import '../../domain/entity/well_work_list_entity.dart';


class WellWorkModel extends WellWorkEntity {
  WellWorkModel({

       required WellWorkListEntity list,
  }) : super(list);

  factory WellWorkModel.fromJson(dynamic json) {
    return WellWorkModel(

        list: WellWorkListModel.fromJson(findFlowMeterElement(json["list"]))
    );
  }
}

dynamic findFlowMeterElement(List<dynamic> list) {

  final allElement = list.firstWhere(
        (element) =>
    element["type"] == "all-well" &&
        element["xAxis"] != null &&   // برای امنیت بیشتر که اگر xAxis نال بود کرش نکند
        element["xAxis"].length > 1,
    orElse: () => null,
  );

  if (allElement != null) return allElement;

// اول تلاش می‌کنه total رو پیدا کنه
  final totalElement = list.firstWhere(
        (element) => element["type"] == "total",
    orElse: () => null,
  );

  if (totalElement != null) return totalElement;

// اگر total نبود، دنبال onwell می‌گرده
  final onWellElement = list.firstWhere(
        (element) => element["type"] == "one-well",
    orElse: () => null,
  );

  if (onWellElement != null) return onWellElement;

// اگر هیچ‌کدوم نبودن خطا میده
  throw Exception("Neither 'total' nor 'onwell' flow meter was found.");
}