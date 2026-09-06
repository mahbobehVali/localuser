import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' show NumberFormat;
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

class VolumeDetailReportChartWidget extends StatelessWidget {
   VolumeDetailReportChartWidget({super.key});

  List<VolumeSlot> flatList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
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
            final amount = val.toString();

            String statusMessage = "نرمال";
            String overCapacity = "۰.۰";
            String disCapacity = "۰.۰";

            final capacityItem = (status.capacityEntity.capacityListEntity != null &&
                i < status.capacityEntity.capacityListEntity!.length)
                ? status.capacityEntity.capacityListEntity![i]
                : null;

            final days = Constants().getDaysBetweenShamsiDates(state.startDate, state.endDate);
            final disconnectCap = (capacityItem?.disconnectCapacity ?? 0) * days;
            final cap = (capacityItem?.capacity ?? 0) * days;
            print("val${val}");
            print("disconnectCap${disconnectCap}");
            print("cap${cap}");

            if (val > disconnectCap) {
              print("yes");
              statusMessage = "اخطار";
              disCapacity = (val - disconnectCap).toString();
              overCapacity = (disconnectCap - cap).toString(); // اگر بحرانی است، یعنی از حد مجاز هم رد شده
            } else if (val > cap) {
              statusMessage = "بیش از حد مجاز";
              overCapacity = (val - cap).toString();
            }

              flatList.add(VolumeSlot(
                name: name,
                amount: amount,
                status: statusMessage,
                capacity: overCapacity,
                disCapacity: disCapacity,
              ));

          }
          int totalItems = xLabels.length;
          double columnWidth = 80.0;
          double calculatedChartWidth = (totalItems * columnWidth).clamp(350.0, 2000.0)+100;

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
            // Color disCapColor = ColorPalette.darkRed;

            // اگر ظرفیت‌ها بیشتر از ۱ عدد نبود (نمودار معمولی)
            if (!hasMultipleCapacity) {
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: yVal,
                    color: normalColor,
                    width: 16.w,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }

            final capacityItem = status.capacityEntity.capacityListEntity?[index];
            // final disconnectCap = (capacityItem?.disconnectCapacity ?? 0) *
            //     getDaysBetweenShamsiDates(state.startDate, state.endDate);
            final cap = (capacityItem?.capacity ?? 0) *
                Constants().getDaysBetweenShamsiDates(state.startDate, state.endDate);
            final dis = (capacityItem?.disconnectCapacity ?? 0) *
                Constants().getDaysBetweenShamsiDates(state.startDate, state.endDate);
            List<BarChartRodStackItem> stackItems = [];

            final double currentVal = yValues[index].toDouble();
            final double capVal = cap.toDouble();
            final double disconnectCapVal = dis.toDouble();
            // final double disconnectCapVal = disconnectCap.toDouble();


            if (currentVal > disconnectCapVal) {
              if (capVal > 0) {
                stackItems.add(BarChartRodStackItem(0, capVal, normalColor));
                stackItems.add(BarChartRodStackItem(capVal, disconnectCapVal, capColor));
                stackItems.add(BarChartRodStackItem(disconnectCapVal, currentVal, disCapColor));
              } else {
                stackItems.add(BarChartRodStackItem(0, disconnectCapVal, normalColor));
                stackItems.add(BarChartRodStackItem(disconnectCapVal, currentVal, disCapColor));
              }
            } else if (currentVal > capVal) {
              stackItems.add(BarChartRodStackItem(0, capVal, normalColor));
              stackItems.add(BarChartRodStackItem(capVal, currentVal, capColor));
            } else {
              stackItems.add(BarChartRodStackItem(0, currentVal, normalColor));
            }

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: yVal, // ارتفاع کل میله دقیقاً برابر با yVal است
                  rodStackItems: stackItems,
                  color: Colors.transparent,
                  width: 16.w,
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
                                    maxContentWidth: 250.w,
                                    getTooltipColor: (group) => ColorPalette.lightGrey,
                                    fitInsideHorizontally: true,
                                    fitInsideVertically: true,
                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                      final item = flatList[groupIndex];

                                      return BarTooltipItem(
                                        'حجم مصرف: ${rod.toY.toString().toPersianDigit()} متر مکعب'
                                            '\nبیش از حد مجاز: ${double.tryParse(item.capacity ?? '')?.toStringAsFixed(3).toPersianDigit() ?? "۰.۰"} متر مکعب'
                                            '\nبیش از حد قطع: ${double.tryParse(item.disCapacity ?? '')?.toStringAsFixed(3).toPersianDigit() ?? "۰.۰"} متر مکعب',
                                        TextStyle(
                                          color: ColorPalette.black,
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
                child: Container(
                  width: 500,
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
                      double? parsedValue = double.tryParse(item.capacity ?? '');
                      double? parsedAmountValue = double.tryParse(item.amount ?? '');
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: ColorPalette.lightGrey, width: 1)),
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text(item.name??"",textAlign: TextAlign.center,)),
                            // Expanded(flex: 3, child: Text('\u200E${item.amount}', textAlign: TextAlign.center)),
                              Expanded(flex: 4, child: Text(parsedAmountValue != null
                                  ? NumberFormat.decimalPattern().format(parsedAmountValue).toPersianDigit()
                                  : "۰.۰",textAlign: TextAlign.center,)),
                            Expanded(flex: 4, child: Text(parsedValue != null
                                  ? NumberFormat.decimalPattern().format(parsedValue).toPersianDigit()
                                  : "۰.۰",textAlign: TextAlign.center,)),

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