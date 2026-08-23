import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/export_to_excel.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_count_status.dart';

class AlertsReportChartWidget extends StatelessWidget {
   AlertsReportChartWidget({super.key});
  List<VolumeSlot> flatList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        final status = state.reportCountStatus;
        if (status is ReportCountSuccess) {
          final countByType = status.alertCountEntity.countByType;

          if (countByType == null || countByType.isEmpty) {
            return Constants.noData();
          }

          List count = countByType.map((e) => e.count).toList();
          List typeName = countByType.map((e) {
            final matchingType = Constants().alertType.firstWhere(
                  (element) => element.id == e.type,
              orElse: () => AlertTypeEntity("نامشخص", -1),
            );
            return matchingType.name;
          }).toList();

          final scale = Constants().getScale(count);
          double chartWidth = (countByType.length * 50.0).clamp(MediaQuery.sizeOf(context).width - 24, double.infinity);

          List<BarChartGroupData> chartGroups = List.generate(countByType.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: double.tryParse(countByType[index].count ?? '0') ?? 0.0,
                  color: ColorPalette.darkBlue,
                  width: 12,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            );
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: BarChart(
                        BarChartData(
                          extraLinesData: ExtraLinesData(
                            horizontalLines: Constants().generateHorizontalLines((scale['step'] as num).toDouble(), scale["maxY"]!,scale["minY"]!),
                          ),
                          maxY: scale['maxY'],
                          minY: scale['minY'],
                          alignment: BarChartAlignment.spaceAround,
                          gridData: const FlGridData(show: false),
                          barTouchData: BarTouchData(
                              handleBuiltInTouches: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => ColorPalette.lightGrey,
                                fitInsideHorizontally: true,
                                fitInsideVertically: true,
                              )
                          ),
                          borderData: FlBorderData(border:  Border(bottom: BorderSide(color: ColorPalette.lightGrey))),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: Constants().axisBottomTitles(typeName, "alertType"),
                            leftTitles: Constants().leftTitles(
                              interval: scale["maxY"]! > 1000 ? 65.w : 40.w,
                              scale: scale['step'] == 0 ? 10 : scale['step']!,
                              title: "تعداد هشدارها"
                            ),
                          ),
                          barGroups: chartGroups,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("جدول اطلاعات تکمیلی نمودار", style: TextStyleP.f12Regular),
                  IconButton(
                      onPressed: () {
                        exportAlertReportToExcel(context, flatList);

                      },
                      icon:Icon(Icons.file_download_outlined))
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(border: Border.all(color: ColorPalette.grey), borderRadius: BorderRadius.circular(5)),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: countByType.length + 1,
                  itemBuilder: (context, index) {

                    if (index == 0) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        color: ColorPalette.lightGrey,
                        child: Row(
                          children: [
                            Expanded(child: Text("نوع هشدار", style: TextStyleP.f10Regular,textAlign: TextAlign.center)),
                            Expanded( child: Text("تعداد هشدارها", style: TextStyleP.f10Regular,textAlign: TextAlign.center)),
                          ],
                        ),
                      );
                    }else{
                      flatList.add(VolumeSlot(
                          name: typeName[index - 1],
                          status: countByType[index - 1].count.toString().toPersianDigit()
                      ));
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(border: BoxBorder.fromLTRB(bottom: BorderSide(color: ColorPalette.grey, width: 1))),
                        child: Row(
                          children: [
                            Expanded(child: Text(typeName[index - 1],textAlign: TextAlign.center)),
                            Expanded(child: Text(countByType[index - 1].count.toString().toPersianDigit(),textAlign: TextAlign.center)),
                          ],
                        ),
                      );
                    }

                  },
                ),
              )
            ],
          );
        }
        if (status is ReportCountLoading) return ShimmerClass.shimmerChartAndListVertical(height: 50);
        if (status is ReportCountError) return Center(child: Text(status.error));
        return const SizedBox.shrink();
      },
    );
  }
}