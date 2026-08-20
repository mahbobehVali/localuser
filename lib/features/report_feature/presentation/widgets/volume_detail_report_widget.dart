import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/export_to_excel.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/report_detail_flow_meter_status.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/indicator_widget.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_flow_meter_status.dart';

class VolumeDetailReportChartWidget extends StatelessWidget {
   VolumeDetailReportChartWidget({super.key});

  List<VolumeSlot> flatList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        int getDaysBetweenShamsiDates(String startDateStr, String endDateStr) {
          // جدا کردن سال، ماه و روز
          final p1 = startDateStr.split('/').map((e) => int.parse(e.trim())).toList();
          final p2 = endDateStr.split('/').map((e) => int.parse(e.trim())).toList();

          // تبدیل تاریخ‌های شمسی به DateTime
          final date1 = Jalali(p1[0], p1[1], p1[2]).toDateTime();
          final date2 = Jalali(p2[0], p2[1], p2[2]).toDateTime();

          // محاسبه اختلاف به روز
          return date2.difference(date1).inDays;
        }
        final status = state.reportDetailFlowMeterStatus;
        if (status is ReportDetailFlowMeterSuccess) {


          final flowMeter = status.wellReportDetailFlowMeter.list;

          final xLabels = flowMeter.xAxis;
          final yValues = flowMeter.yAxis;


          if (xLabels == null || yValues == null || xLabels.isEmpty || yValues.isEmpty) {
            return Constants.noData();
          }

          final scale = Constants().getScale(yValues);

        // ۱. ساخت و پر کردن flatList قبل از رندر UI

          for (int i = 0; i < yValues.length; i++) {
            final val = yValues[i];
            String name=xLabels[i].toString().toPersianDigit();
            final amount = val.toString().toPersianDigit();

            String statusMessage = "نرمال";
            String overCapacity = "۰.۰";

              final capacityItem = status.capacityEntity.capacityListEntity?[i];
              final disconnectCap = (capacityItem?.disconnectCapacity ?? 0) *
                  getDaysBetweenShamsiDates(state.startDate, state.endDate);
              final cap = (capacityItem?.capacity ?? 0) *
                  getDaysBetweenShamsiDates(state.startDate, state.endDate);

              if (val > disconnectCap) {
                statusMessage = "اخطار";
              } else if (val > cap) {
                statusMessage = "بیش از حد مجاز";
              }

              if (val > cap) {
                overCapacity = (val - cap).toString().toPersianDigit();
              }else if (val > disconnectCap) {
                overCapacity = (val - disconnectCap).toString().toPersianDigit();
              }

              flatList.add(VolumeSlot(
                name: name,
                amount: amount,
                status: statusMessage,
                capacity: overCapacity,
              ));

          }
          int totalItems = xLabels.length;
          double columnWidth = 80.0;
          double calculatedChartWidth = (totalItems * columnWidth).clamp(350.0, 2000.0);

          List<BarChartGroupData> chartGroups = List.generate(xLabels.length, (index) {
            final double yVal = index < yValues.length ? yValues[index].toDouble() : 0.0;
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
            final capacityList = status.capacityEntity.capacityListEntity;
            final bool hasMultipleCapacity = capacityList != null ;

            Color normalColor = ColorPalette.darkBlue;
            Color capColor = ColorPalette.orange;
            Color disCapColor = ColorPalette.darkRed;

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

            final capacityItem = status.capacityEntity.capacityListEntity?[index];
            final disconnectCap = (capacityItem?.disconnectCapacity ?? 0) *
                getDaysBetweenShamsiDates(state.startDate, state.endDate);
            final cap = (capacityItem?.capacity ?? 0) *
                getDaysBetweenShamsiDates(state.startDate, state.endDate);
            List<BarChartRodStackItem> stackItems = [];

            final double currentVal = yValues[index].toDouble();
            final double capVal = cap.toDouble();
            final double disconnectCapVal = disconnectCap.toDouble();

            // if (currentVal > disconnectCapVal) {
            //   // اگر از حد قطع بیشتر است، باید لایه‌ها به ترتیب زیر روی هم چیده شوند:
            //
            //   // ۱. لایه اول: از صفر تا ظرفیت عادی
            //   if (capVal > 0) {
            //     stackItems.add(BarChartRodStackItem(0, capVal, normalColor));
            //     // ۲. لایه دوم: از ظرفیت عادی تا ظرفیت قطعی
            //     stackItems.add(BarChartRodStackItem(capVal, disconnectCapVal, capColor));
            //     // ۳. لایه سوم: از ظرفیت قطعی تا مقدار کل مصرف
            //     stackItems.add(BarChartRodStackItem(disconnectCapVal, currentVal, disCapColor));
            //   } else {
            //     stackItems.add(BarChartRodStackItem(0, disconnectCapVal, normalColor));
            //     stackItems.add(BarChartRodStackItem(disconnectCapVal, currentVal, disCapColor));
            //   }
            //
            // }
            // else if (currentVal > capVal) {
            //   // اگر فقط از ظرفیت عادی رد کرده ولی به حد قطع نرسیده است
            //   stackItems.add(BarChartRodStackItem(0, capVal, normalColor));
            //   stackItems.add(BarChartRodStackItem(capVal, currentVal, capColor));
            // }
            // else {
            //   // اگر کمتر از هر دو حد مجاز باشد
            //   stackItems.add(BarChartRodStackItem(0, currentVal, normalColor));
            // }


            if (currentVal > capVal) {
              // اگر مصرف از ظرفیت عادی بیشتر است، میله به دو لایه تقسیم می‌شود:

              // ۱. لایه اول: از صفر تا ظرفیت عادی (رنگ نرمال)
              stackItems.add(BarChartRodStackItem(0, capVal, normalColor));

              // ۲. لایه دوم: از ظرفیت عادی تا مقدار کل مصرف (رنگ اخطار / بیش از حد مجاز)
              stackItems.add(BarChartRodStackItem(capVal, currentVal, capColor));
            }
            else {
              // اگر مصرف کمتر یا مساوی ظرفیت مجاز باشد (فقط یک لایه)
              stackItems.add(BarChartRodStackItem(0, currentVal, normalColor));
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
            Column(
              children: [
                Directionality(
                    textDirection: TextDirection.ltr,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: calculatedChartWidth,

                        height: 300,
                        child: Padding(
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
                                border:  Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                              ),
                              barTouchData: BarTouchData(
                                  handleBuiltInTouches: true,
                                  touchTooltipData: BarTouchTooltipData(
                                    getTooltipColor: (group) => ColorPalette.lightGrey,
                                    fitInsideHorizontally: true,
                                    fitInsideVertically: true,
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      final item = flatList[groupIndex];

                                      return BarTooltipItem(
                                        'حجم مصرف: \u200E${rod.toY.toString().toPersianDigit()}\nبیش از حد مجاز: ${item.capacity}',
                                        TextStyle(
                                          color: ColorPalette.darkBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),

                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: Constants().axisBottomTitles(xLabels,
                                  flowMeter.type=="all-well" ? "nothing" :
                                state.startDate==state.endDate ? "day" :  "date",),
                                leftTitles: Constants().leftTitles(
                                  interval: scale["maxY"]! > 1000 ? 65.w : 40.w,
                                  scale: scale['step'] == 0 ? 10 : scale['step']!,
                                ),
                              ),
                              barGroups: chartGroups,
                            ),
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
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("جدول اطلاعات تکمیلی نمودار", style: TextStyleP.f12Regular),
                  IconButton(
                    onPressed: () {
                      exportVolumeToExcel(context, flatList, 1);
                      
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
                              Expanded(flex: 4, child: Text(state.selectedReportIndex == 1 ? "چاه" : "تاریخ", style: TextStyleP.f10Regular,textAlign: TextAlign.center,)),
                              Expanded(flex: 3, child: Text("میزان حجم مصرف کل", style: TextStyleP.f10Regular,textAlign: TextAlign.center,)),
                                Expanded(flex: 4, child: Text("حجم مصرف بیش از حد مجاز", style: TextStyleP.f10Regular,textAlign: TextAlign.center,)),
                              Expanded(flex: 2, child: Text("وضعیت", style: TextStyleP.f10Regular,textAlign: TextAlign.center,)),
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
                            Expanded(flex: 4, child: Text(item.name??"",textAlign: TextAlign.center,)),
                            Expanded(flex: 3, child: Text('\u200E${item.amount}', textAlign: TextAlign.center)),
                              Expanded(flex: 4, child: Text(item.capacity ?? "۰.۰",textAlign: TextAlign.center,)),
                            Expanded(flex: 2, child: Text(item.status??"", textAlign: TextAlign.center)),
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
        if (status is ReportDetailFlowMeterLoading) return ShimmerClass.shimmerBarChartAndListVertical();
        if (status is ReportDetailFlowMeterError) return Center(child: Text(status.error));
        return const SizedBox.shrink();
      },
    );
  }


}