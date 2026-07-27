import 'package:mahaliii/features/well_feature/data/model/well_flowmeter_list_model.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_flowmeter_entity.dart';

import '../../domain/entity/well_flowmeter_list_entity.dart';

// ReportFlowMeter1
class WellFlowMeterModel extends WellFlowMeterEntity {
  WellFlowMeterModel({

       required WellFlowMeterListEntity list,
  }) : super(list);

  factory WellFlowMeterModel.fromJson(dynamic json, {bool ignoreAllWell = false}) {
    return WellFlowMeterModel(

        list: WellFlowMeterListModel.fromJson(findFlowMeterElement(json["list"],
            ignoreAllWell: ignoreAllWell))
    );
  }

}

 dynamic findFlowMeterElement(List<dynamic> list,{bool ignoreAllWell = false}) {
   // ۱. بررسی شرط all-well فقط در صورتی که نادیده گرفته نشده باشد
   if (!ignoreAllWell) {
     final allElement = list.firstWhere(
           (element) =>
       element["type"] == "all-well" &&
           element["xAxis"] != null &&
           element["xAxis"].length > 1,
       orElse: () => null,
     );

     if (allElement != null) return allElement;
   }

    // اول تلاش می‌کنه total رو پیدا کنه
    final totalElement = list.firstWhere(
      (element) => element["type"] == "total",
      orElse: () => null,
    );

    if (totalElement != null) return totalElement;

    // // اگر total نبود، دنبال onwell می‌گرده
    // final onwellElement = list.firstWhere(
    //   (element) => element["type"] == "one-well",
    //   orElse: () => null,
    // );
    //
    // if (onwellElement != null) return onwellElement;

    // اگر هیچ‌کدوم نبودن خطا میده
    throw Exception("Neither 'total' nor 'onwell' flow meter was found.");
}