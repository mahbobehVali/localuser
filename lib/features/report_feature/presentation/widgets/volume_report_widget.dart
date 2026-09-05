import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:mahaliii/common/widgets/export_to_excel.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_flow_meter_status.dart';

class VolumeReportChartWidget extends StatelessWidget {
   VolumeReportChartWidget({super.key});

  List<VolumeSlot> flatList = [];
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        final status = state.reportFlowMeterStatus;
        if (status is ReportFlowMeterSuccess) {
          print("status.wellReportFlowMeter.list${status.wellReportFlowMeter.list.xAxis}");

          final flowMeter = status.wellReportFlowMeter.list;
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

          for (int i = 0; i < yValues.length; i++) {
            final val = yValues[i];
            print("xLabels[i]${xLabels[i]}");
             final parts = xLabels[i].split('/');
             final monthNum = int.tryParse(parts[1]) ?? 0;

            String name =  getDaysBetweenShamsiDates(state.startDate, state.endDate)<31?
             xLabels[i].toString().toPersianDigit():Constants().monthNames[monthNum - 1];

            final amount = val.toString();

            String statusMessage = "نرمال";

              if (val > (status.capacityEntity.totalDisconnectCapacity??0)*getDaysBetweenShamsiDates(state.startDate, state.endDate)) {
                statusMessage = "اخطار";
              }
              else if (val > (status.capacityEntity.totalCapacity??0)*getDaysBetweenShamsiDates(state.startDate, state.endDate)) {
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

                              state.startDate==state.endDate ? "day" :  "date",
                              leng: getDaysBetweenShamsiDates(state.startDate, state.endDate)
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
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              maxContentWidth: 250.w,
                              getTooltipColor: (LineBarSpot touchedSpot) => ColorPalette.lightGrey,
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final int xIndex = spot.x.toInt();
                                  // پیدا کردن تاریخ مربوط به این نقطه
                                  final String dateStr = (xIndex >= 0 && xIndex < xLabels.length)
                                      ? xLabels[xIndex].toString().toPersianDigit()
                                      : "";

                                  // فرمت کردن مقدار عدد (با مدیریت علامت منفی)
                                  final double val = spot.y;
                                  final String formattedVal = val < 0
                                      ? "-${(-val).toStringAsFixed(1).toString().toPersianDigit()}"
                                      : val.toStringAsFixed(1).toString().toPersianDigit();

                                  return LineTooltipItem(
                                    '',
                                    const TextStyle(),
                                    textAlign: TextAlign.right,
                                    children: [
                                      // ۱. نمایش تاریخ در خط اول
                                      TextSpan(
                                        text: "$dateStr\n",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "_________________\n",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                        ),
                                      ),
                                      // ۲. مقدار عدد (کاملاً در سمت چپ با ایزوله‌سازی LTR)
                                      TextSpan(
                                        text: "\u2066$formattedVal\u2069",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      // ۳. فاصله
                                      const TextSpan(
                                        text: " ",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      // ۴. برچسب و دو نقطه (با روشی که دو نقطه سر جایش بماند و نرود سمت چپ)
                                      // با گذاشتن کاراکتر جهت‌دار راست‌به‌راست (RLI) دور برچسب
                                      const TextSpan(
                                        text: "\u202bحجم مصرف:\u202c",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList();
                              },
                            ),
                          ),

                          lineBarsData: [
                            LineChartBarData(
                              preventCurveOverShooting: true,
                              // preventCurveOvershootingThreshold: 0,
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

              Container(
                decoration: BoxDecoration(
                    border: BoxBorder.all(color: ColorPalette.lightGrey),
                    borderRadius: BorderRadius.circular(5)
                ),
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
                            Expanded( child: Text( "تاریخ",
                                style: TextStyleP.f10Regular, textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text("میزان حجم مصرف کل", style: TextStyleP.f10Regular, textAlign: TextAlign.center)),
                            Expanded( child: Text("وضعیت", style: TextStyleP.f10Regular, textAlign: TextAlign.center)),
                          ],
                        ),
                      );
                    }

                    // دسترسی آسان به دیتای آماده از flatList
                    final item = flatList[index - 1];
                    double? parsedAmountValue = double.tryParse(item.amount ?? '');

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: ColorPalette.lightGrey, width: 1)),
                      ),
                      child: Row(
                        children: [
                          Expanded( child: Text(item.name??"", textAlign: TextAlign.center)),
                          Expanded(flex: 2, child: Text(parsedAmountValue != null
                              ? NumberFormat.decimalPattern().format(parsedAmountValue).toPersianDigit()
                              : "۰.۰",textAlign: TextAlign.center,)),
                          Expanded( child: Text(item.status??"", textAlign: TextAlign.center)),
                        ],
                      ),
                    );
                  },
                ),
              )

            ],
          );
        }
        if (status is ReportFlowMeterLoading) return ShimmerClass.shimmerChartAndListVertical();
        if (status is ReportFlowMeterError) return Center(child: Text(status.error));
        if (status is ReportFlowMeterInitial) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 250.h,
              child: Center(child: Text("لطفاً فیلتر مورد نیاز خود را اعمال کنید")),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }


}