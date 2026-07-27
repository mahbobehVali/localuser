//
// import 'package:mahaliii/features/well_feature/domain/entity/well_work_list_series_entity.dart';
//
//
// class WellWorkListSeriesModel extends WellWorkListSeriesEntity {
//   WellWorkListSeriesModel({
//      String? name,
//      int? id,
//     List<dynamic>? xAxis,
//     List<dynamic>? yAxis,
//
//   }) : super(name,id, xAxis,yAxis);
//
//   factory WellWorkListSeriesModel.fromJson(dynamic json) {
//
//     return WellWorkListSeriesModel(
//       name: json["name"],
//       id: json["id"],
//       xAxis: json["xAxis"],
//       yAxis: json["yAxis"],
//
//     );
//   }
//
//   static List<WellWorkListSeriesEntity> parseList(List<dynamic> jsonArray) {
//     List<WellWorkListSeriesEntity> data = [];
//
//     for (var element in jsonArray) {
//       data.add(WellWorkListSeriesModel.fromJson(element));
//     }
//
//     return data;
//   }
// }
//
//
//
