import 'package:mahaliii/features/status_summary_feature/data/model/summary_flowmeter_list_model.dart';

import '../../domain/entity/summary_flowmeter_entity.dart';
import '../../domain/entity/summary_flowmeter_list_entity.dart';

class SummaryFlowMeterModel extends SummaryFlowMeterEntity {
  SummaryFlowMeterModel({

       required SummaryFlowMeterListEntity list,
  }) : super(list);

  factory SummaryFlowMeterModel.fromJson(dynamic json) {
    return SummaryFlowMeterModel(

        list: SummaryFlowMeterListModel.fromJson(findFlowMeterElement(json["list"]))
    );
  }

}

dynamic findFlowMeterElement(List<dynamic> list) {

  final onwellElement = list.firstWhere(
        (element) => element["type"] == "multi-line",
    orElse: () => null,
  );
  if (onwellElement != null) return onwellElement;

  // final totalElement = list.firstWhere(
  //       (element) => element["type"] == "total",
  //   orElse: () => null,
  // );
  // if (totalElement != null) return totalElement;


// اگر هیچ‌کدوم نبودن خطا میده
  throw Exception("Neither 'total' nor 'onwell' flow meter was found.");
}
