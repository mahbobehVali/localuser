import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/export_to_excel.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_command_status.dart';

class PumpHoursChartWidget extends StatelessWidget {
   PumpHoursChartWidget({super.key});
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
        final status = state.reportCommandStatus;
        if (status is ReportCommandSuccess) {
          final flowMeter = status.reportFlowMeter.list;
          final xLabels = flowMeter.xAxis;
          final yValues = flowMeter.yAxis;

          if (xLabels == null || xLabels.isEmpty || yValues == null || yValues.isEmpty) {
            return Constants.noData();
          }

          if(state.oneWell.length==1 ){

            for (int i = 0; i < yValues.length; i++) {
              final val = yValues[i];
              final parts = xLabels[i].split('/');
              final monthNum = int.tryParse(parts[1]) ?? 0;

              String name =  getDaysBetweenShamsiDates(state.startDate, state.endDate)<31?
              xLabels[i].toString().toPersianDigit():Constants().monthNames[monthNum - 1];

              final amount= val.toString().toPersianDigit()  ;
              flatList.add(VolumeSlot(
                  name: name,
                  amount: amount
              ));

            }
          }else{
            for (int i = 0; i < yValues.length; i++) {
              final val = yValues[i];

              String name = xLabels[i].toString().toPersianDigit();

              final amount= val.toString().toPersianDigit()  ;
              flatList.add(VolumeSlot(
                  name: name,
                  amount: amount
              ));

            }
          }




          final scale = Constants().getScale(yValues);
          double chartWidth = (xLabels.length * 20.0).clamp(MediaQuery.sizeOf(context).width, double.infinity)+100;

          List<BarChartGroupData> chartGroups = List.generate(xLabels.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: index < yValues.length ? yValues[index].toDouble() : 0.0,
                  color: ColorPalette.darkBlue,
                  width: 12,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            );
          });
          print(flatList.length + 1);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: Directionality(
                  textDirection: TextDirection.ltr,
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
                                  maxContentWidth: 250.w,
                                  getTooltipColor: (group) => ColorPalette.lightGrey,
                                  fitInsideHorizontally: true,
                                  fitInsideVertically: true,
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    final int xIndex = group.x.toInt();
                                    // پیدا کردن تاریخ مربوط به این نقطه
                                    final String dateStr = (xIndex >= 0 && xIndex < xLabels.length)
                                        ? xLabels[xIndex].toString().toPersianDigit()
                                        : "";

                                    // فرمت کردن مقدار عدد از روی rod.toY (با مدیریت علامت منفی)
                                    final double val = rod.toY;
                                    final String formattedVal = val < 0
                                        ? "-${(-val).toStringAsFixed(1).toString().toPersianDigit()}"
                                        : val.toStringAsFixed(1).toString().toPersianDigit();

                                    return BarTooltipItem(
                                      '', // متن اصلی خالی
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
                                        // ۴. برچسب و دو نقطه
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
                                  },
                                )
                            ),
                            borderData: FlBorderData(border:  Border(bottom: BorderSide(color: ColorPalette.lightGrey))),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: Constants().axisBottomTitles(xLabels,
                                  flowMeter.type=="all-well"?"nothing":flowMeter.type=="one-well"?"clock":"date",
                              leng: getDaysBetweenShamsiDates(state.startDate, state.endDate)),

                              leftTitles: Constants().leftTitles(
                                interval: scale["maxY"]! > 1000 ? 65.w : 40.w,
                                scale: scale['step'] == 0 ? 10 : scale['step']!,

                                title: "ساعت"
                              ),
                            ),
                            barGroups: chartGroups,
                          ),
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
                        exportPumpToExcel(context, flatList,state.oneWell.length);

                      },
                      icon:Icon(Icons.file_download_outlined))
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: ColorPalette.lightGrey),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: flatList.length + 1,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        padding:  EdgeInsets.symmetric(vertical: 10.h),

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                          color: ColorPalette.lightGrey,
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text( state.oneWell.length==1? "تاریخ":"چاه", style: TextStyleP.f10Regular,textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text("مجموع ساعات کارکرد پمپ", style: TextStyleP.f10Regular,textAlign: TextAlign.center)),
                          ],
                        ),
                      );
                    }else{

                      final item = flatList[index - 1];

                      return Container(
                        padding:  EdgeInsets.symmetric( vertical: 20),
                        decoration: BoxDecoration(border: BoxBorder.fromLTRB(bottom: BorderSide(color: ColorPalette.lightGrey, width: 1))),
                        child: Row(
                          children: [
                            Expanded(flex: 2, child: Text(item.name.toString().toPersianDigit(),textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text('\u200E${item.amount}',textAlign: TextAlign.center)),
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
        if (status is ReportCommandLoading) return ShimmerClass.shimmerChartAndListVertical(height: 50);
        if (status is ReportCommandError) return Center(child: Text(status.error));
        return const SizedBox.shrink();
      },
    );
  }
}