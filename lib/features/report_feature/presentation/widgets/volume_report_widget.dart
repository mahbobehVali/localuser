import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/export_to_excel.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
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

          int totalItems = xLabels.length;
          double columnWidth = 80.0;
          double calculatedChartWidth = (totalItems * columnWidth).clamp(350.0, 2000.0);
          List<String> capacity=[];

          List<BarChartGroupData> chartGroups = List.generate(xLabels.length, (index) {
            final double yVal = index < yValues.length ? yValues[index].toDouble() : 0.0;

            final capacityList = status.capacityEntity.capacityListEntity;
            final bool hasMultipleCapacity = capacityList != null && state.selectedReportIndex==1 ;

             Color normalColor = ColorPalette.darkBlue;
             Color exceedColor = ColorPalette.lightGrey;

            // اگر ظرفیت‌ها بیشتر از ۱ عدد نبود (نمودار معمولی)
            if (!hasMultipleCapacity) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: yVal,
                    color: normalColor,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }

            // حالت دوم: مقایسه با capacity و دو رنگه کردن میله
            final double capacityVal = index < capacityList.length
                ? double.tryParse(capacityList[index].capacity?.toString() ?? '0') ?? 0.0
                : 0.0;

            if (yVal == 0) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: 0,
                    color: Colors.transparent,
                    width: 12,
                  ),
                ],
              );
            }

            List<BarChartRodStackItem> stackItems = [];

            if (yVal > capacityVal*xLabels.length) {
              // لایه اول: از 0 تا capacityVal -> رنگ آبی
              stackItems.add(BarChartRodStackItem(0, capacityVal, normalColor));

              // لایه دوم: از capacityVal تا yVal -> رنگ قرمز
              stackItems.add(BarChartRodStackItem(capacityVal, yVal, exceedColor));
            }
            // سناریو ب: y کمتر یا برابر capacity است (مثلاً y=700 و capacity=900)
            else {
              // فقط یک لایه: از 0 تا 700 -> رنگ آبی
              stackItems.add(BarChartRodStackItem(0, yVal, normalColor));
            }

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: yVal, // ارتفاع کل میله دقیقاً برابر با yVal است
                  rodStackItems: stackItems,
                  color: Colors.transparent,
                  width: 12,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            );
          });
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            state.selectedReportIndex==1?
            Column(
              children: [
                Directionality(
                    textDirection: TextDirection.ltr,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: calculatedChartWidth,

                        height: 300,
                        padding: const EdgeInsets.only(top: 40, right: 18.0,bottom: 10),
                        child: BarChart(
                          BarChartData(
                            extraLinesData: ExtraLinesData(
                              horizontalLines: Constants().generateHorizontalLines((scale['step'] as num).toDouble(), scale["maxY"]!,scale["minY"]!),
                            ),
                            maxY: scale['maxY'],
                            //  تنظیم هوشمند مبدأ روی صفر (در صورت نداشتن مقدار منفی)
                            minY: (scale['minY'] != null && scale['minY']! < 0) ? scale['minY'] : 0.0,

                            alignment: BarChartAlignment.spaceAround,
                            gridData: FlGridData(
                              show: false,
                              verticalInterval: scale['step'],
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  strokeWidth: 1,
                                  color: Colors.grey,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              border: const Border(bottom: BorderSide(), left: BorderSide()),
                            ),
                            barTouchData: BarTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (group) => ColorPalette.lightGrey,
                                  fitInsideHorizontally: true, // جلوگیری از بیرون زدن افقی از چپ/راست
                                  fitInsideVertically: true,   // جلوگیری از بیرون زدن عمودی از بالا/پایین
                                )
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: Constants().axisBottomTitles(xLabels, "nothing"),
                              leftTitles: Constants().leftTitles(
                                interval: scale["maxY"]! > 1000 ? 65.w : 40.w,
                                scale: scale['step'] == 0 ? 10 : scale['step']!,
                              ),
                            ),
                            barGroups: chartGroups,
                          ),
                        )
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Indicator(color: ColorPalette.inverseGrey, text: 'حجم مصرف بیش از حد مجاز'),
                    Indicator(color: ColorPalette.darkBlue, text: 'حجم مصرفی'),
                  ],

                ),
                SizedBox(height: 16.h,)
              ],
            ):
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
                          borderData: FlBorderData(show: true, border: const Border(bottom: BorderSide(), left: BorderSide())),
                          titlesData: FlTitlesData(
                            bottomTitles: Constants().axisBottomTitles(
                              xLabels,
                              flowMeter.type=="all-well" ? "nothing" : state.startDate==state.endDate ? "day" :  "date",
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
                  Text("جدول اطلاعات تکمیلی نمودار ", style: TextStyleP.f12Regular),
                  IconButton(
                    onPressed: () {
                      exportVolumeToExcel(context, flatList, state.selectedReportIndex!);
                      
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
                    itemCount: yValues.length + 1,
                    itemBuilder: (context, index) {
                      String statusMessage = "نرمال";

                      if (state.selectedReportIndex == 1) {
                        final item = status.capacityEntity.capacityListEntity![index - 1];
                        final currentY = yValues[index - 1];
                        final totalLength = xLabels.length;

                        if (currentY > (item.disconnectCapacity! * totalLength)) {
                          statusMessage = "اخطار";
                        } else if (currentY > (item.capacity! * totalLength)) {
                          statusMessage = "بیش از حد مجاز";
                        }
                      }

                      // flatList.add(
                      //   VolumeSlot(
                      //     xLabels[index - 1].toString().toPersianDigit(),
                      //     capacity[index - 1],
                      //     yValues[index - 1],
                      //     statusMessage,
                      //   ),
                      // );

                      if (index == 0) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          color: ColorPalette.lightGrey,
                          child: Row(
                            children: [
                              Expanded(flex: 4, child: Text("تاریخ", style: TextStyleP.f10Regular)),
                              Expanded(flex: 3, child: Text("میزان حجم مصرف کل", style: TextStyleP.f10Regular)),
                              if(state.selectedReportIndex==1)
                                Expanded(flex: 4, child: Text("حجم مصرف بیش از حد مجاز", style: TextStyleP.f10Regular)),
                              Expanded(flex: 2, child: Text("وضعیت", style: TextStyleP.f10Regular)),
                            ],
                          ),
                        );
                      }
                      final val = yValues[index - 1];

                      if (state.selectedReportIndex==1){

                         capacity.add(yValues[index - 1] >
                         status.capacityEntity.capacityListEntity![index-1].disconnectCapacity!*xLabels.length ? "اخطار" :
                         yValues[index - 1] >
                         status.capacityEntity.capacityListEntity![index-1].capacity!*xLabels.length
                         ? "بیش از حد مجاز"
                             : "نرمال");


                      }else{
                        capacity.add(yValues[index-1]>(status.capacityEntity.totalDisconnectCapacity)?"اخطار":
                        yValues[index-1]>(status.capacityEntity.totalCapacity)?"بیش از حد مجاز":"نرمال");
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(border: BoxBorder.fromLTRB(bottom: BorderSide(color: ColorPalette.grey, width: 1))),
                        child: Row(
                          children: [
                            Expanded(flex:4,child: Text(xLabels[index - 1].toString().toPersianDigit())),
                            Expanded(flex:3,child: Text('\u200E$val'.toString().toPersianDigit(), textAlign: TextAlign.start)),

                            if(state.selectedReportIndex==1)
                              Expanded(flex:4,child: Text(
                                  (val > status.capacityEntity.capacityListEntity![index-1].capacity!*xLabels.length)?
                                      (val-(status.capacityEntity.capacityListEntity![index-1].capacity!*xLabels.length)).toString().toPersianDigit()
                                      : "۰.۰"

                            )),
                            Expanded(flex:2,child: Text(capacity[index-1], textAlign: TextAlign.start)),
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