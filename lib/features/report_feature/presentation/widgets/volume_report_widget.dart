import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/export_to_excel.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/indicator_widget.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_flow_meter_status.dart';

class VolumeReportChartWidget extends StatelessWidget {
   VolumeReportChartWidget({super.key});

  List<VolumeSlot> flatList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        final status = state.reportFlowMeterStatus;
        if (status is ReportFlowMeterSuccess) {

          final flowMeter = status.reportFlowMeter.list;
          final xLabels = flowMeter.xAxis;
          final yValues = flowMeter.yAxis;

          if (xLabels == null || yValues == null || xLabels.isEmpty || yValues.isEmpty) {
            return Constants.noData();
          }

          final scale = Constants().getScale(yValues);

          List<FlSpot> spots = List.generate(
            xLabels.length,
                (j) => j < yValues.length && yValues[j] != null ? FlSpot(j.toDouble(), yValues[j].toDouble()) : null,
          ).whereType<FlSpot>().toList();

          if (spots.isEmpty) return Constants.noData();
        // ۱. ساخت و پر کردن flatList قبل از رندر UI

          final firstParts = xLabels.first?.toString().split('/') ?? [];
          final firstMonth = firstParts.length > 1 ? firstParts[1] : null;
          final bool isSameMonthForAll = xLabels.every((element) {
            final p = element.toString().split('/');
            return p.length > 1 && p[1] == firstMonth;
          });

          for (int i = 0; i < yValues.length; i++) {
            final val = yValues[i];
             final parts = xLabels[i].split('/');
             final monthNum = int.tryParse(parts[1]) ?? 0;

            String name =  isSameMonthForAll?
             xLabels[i].toString().toPersianDigit():Constants().monthNames[monthNum - 1];

            final amount = val.toString().toPersianDigit();

            String statusMessage = "نرمال";

              if (val > status.capacityEntity.totalDisconnectCapacity) {
                statusMessage = "اخطار";
              }
              else if (val > status.capacityEntity.totalCapacity) {
                statusMessage = "بیش از حد مجاز";
              }

              flatList.add(VolumeSlot(
                name: name,
                amount: amount,
                status: statusMessage,
              ));

          }
          int totalItems = xLabels.length;
          double columnWidth = 80.0;
          double calculatedChartWidth = (totalItems * columnWidth).clamp(350.0, 2000.0);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Directionality(
                textDirection: TextDirection.ltr,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: calculatedChartWidth,
                    height: 400,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
                      child: LineChart(

                        LineChartData(
                          extraLinesData: ExtraLinesData(
                            horizontalLines: Constants().generateHorizontalLines((scale['step'] as num).toDouble(), scale["maxY"]!,scale["minY"]!),
                          ),
                          borderData: FlBorderData(show: true, border: Border(bottom: BorderSide(color: ColorPalette.lightGrey))),
                          titlesData: FlTitlesData(
                            bottomTitles: Constants().axisBottomTitles(
                              xLabels,
                              flowMeter.type=="all-well" ? "nothing" :
                              state.startDate==state.endDate ? "day" :  "date",
                            ),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: Constants().leftTitles(
                              interval: scale["maxY"]! > 1000 ? 55.w : 40.w,
                              scale: scale['step'] == 0 ? 10 : scale['step']!,
                            ),
                          ),
                          gridData: const FlGridData(show: false),
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (LineBarSpot touchedSpot) => ColorPalette.lightGrey,
                              fitInsideHorizontally: true, // جلوگیری از بیرون زدن افقی از چپ/راست
                              fitInsideVertically: true,   // جلوگیری از بیرون زدن عمودی از بالا/پایین
                            ),
                            handleBuiltInTouches: true,
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              preventCurveOverShooting: true,
                              preventCurveOvershootingThreshold: 0,
                              dotData: const FlDotData(show: false ),
                              isCurved: true,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [ColorPalette.darkBlue.withValues(alpha: 0.9), ColorPalette.darkBlue.withValues(alpha: 0.5)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),

                              color: ColorPalette.darkBlue,
                              barWidth: 2.5,
                              isStrokeCapRound: true,
                              spots: spots,
                            ),
                          ],

                          maxY: scale["maxY"],
                          minY: scale["minY"],
                        ),
                        duration: const Duration(milliseconds: 250),
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
                      exportVolumeToExcel(context, flatList, 0);
                      
                    },
                      icon:Icon(Icons.file_download_outlined))
                ],
              ),
              SizedBox(height: 8.h,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 500,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: flatList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          color: ColorPalette.lightGrey,
                          child: Row(
                            children: [
                              Expanded(flex: 4, child: Text(state.selectedReportIndex == 1 ? "چاه" : "تاریخ", style: TextStyleP.f10Regular)),
                              Expanded(flex: 3, child: Text("میزان حجم مصرف کل", style: TextStyleP.f10Regular)),
                              Expanded(flex: 2, child: Text("وضعیت", style: TextStyleP.f10Regular)),
                            ],
                          ),
                        );
                      }

                      // دسترسی آسان به دیتای آماده از flatList
                      final item = flatList[index - 1];

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: ColorPalette.grey, width: 1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text(item.name??"")),
                            Expanded(flex: 3, child: Text('\u200E${item.amount}', textAlign: TextAlign.start)),
                            Expanded(flex: 2, child: Text(item.status??"", textAlign: TextAlign.start)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )

            ],
          );
        }
        if (status is ReportFlowMeterLoading) return ShimmerClass.shimmerChartAndListVertical();
        if (status is ReportFlowMeterError) return Center(child: Text(status.error));
        if (status is ReportFlowMeterInitial) {
          return Center(child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text("لطفاً فیلتر مورد نیاز خود را اعمال کنید"),
        ));
        }
        return const SizedBox.shrink();
      },
    );
  }


}