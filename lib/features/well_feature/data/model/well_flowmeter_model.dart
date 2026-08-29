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

        list: WellFlowMeterListModel.fromJson( findFlowMeterElement(json["list"],
            ignoreAllWell: ignoreAllWell))
    );
  }

}

 dynamic findFlowMeterElement(List<dynamic> list,{bool ignoreAllWell = false}) {
  // print("ignoreAllWell------${ignoreAllWell}");
   // ۱. بررسی شرط all-well فقط در صورتی که نادیده گرفته نشده باشد
   if (ignoreAllWell==false) {
     final allElement = list.firstWhere(
           (element) =>
       element["type"] == "all-well" &&
           element["xAxis"] != null &&
           element["xAxis"].length > 1,
       orElse: () => null,
     );
     print("totalElementall-well${allElement}");

     if (allElement != null) return allElement;
   }
  print("tttttttttttttttttttttttttttt");

    // اول تلاش می‌کنه total رو پیدا کنه
    final totalElement = list.firstWhere(
      (element) => element["type"] == "total",
      orElse: () => null,
    );
   print("totalElementtotal${totalElement}");

    if (totalElement != null) return totalElement;



    final oneElement = list.firstWhere(
      (element) => element["type"] == "one-well",
      orElse: () => null,
    );
   print("oneElementone-well${oneElement}");

    if (oneElement != null) return oneElement;

   // final deviceElement = list.firstWhere(
   //       (element) => element["deviceId"] !=null && element["deviceId"].toString().isNotEmpty,
   //   orElse: () => null,
   // );
   // print("totalElement${totalElement}");
   //
   // if (deviceElement != null) return deviceElement;
   //

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