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
        final status = state.reportFlowMeterStatus;
        if (status is ReportFlowMeterSuccess) {


          final flowMeter = status.wellReportFlowMeter.list;

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

            final capacityList = status.capacityEntity.capacityListEntity;
            final bool hasMultipleCapacity = capacityList != null ;

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

            if (yVal > capacityVal*getDaysBetweenShamsiDates(state.startDate, state.endDate)) {
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
                              border:  Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                            ),
                            barTouchData: BarTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (group) => ColorPalette.lightGrey,
                                  fitInsideHorizontally: true,
                                  fitInsideVertically: true,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      rod.toY.toString().toPersianDigit(),
                                       TextStyle(
                                        color: ColorPalette.darkBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    );
                                  },
                                )
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
        if (status is ReportFlowMeterLoading) return ShimmerClass.shimmerBarChartAndListVertical();
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