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
import '../bloc/report_bloc.dart';
import '../bloc/report_command_status.dart';

class PumpHoursChartWidget extends StatelessWidget {
   PumpHoursChartWidget({super.key});
  List<VolumeSlot> flatList = [];

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

          if(state.oneWell.length==1){
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

              final amount= val.toString().toPersianDigit()  ;
              flatList.add(VolumeSlot(
                  name: name,
                  amount: amount
              ));

            }
          }

          for (int i = 0; i < yValues.length; i++) {
            final val = yValues[i];

            String name = xLabels[i].toString().toPersianDigit();

            final amount= val.toString().toPersianDigit()  ;
            flatList.add(VolumeSlot(
                name: name,
                amount: amount
            ));

          }


          final scale = Constants().getScale(yValues);
          double chartWidth = (xLabels.length * 20.0).clamp(MediaQuery.sizeOf(context).width, double.infinity);

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
                                maxContentWidth: 250.w,
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
                            bottomTitles: Constants().axisBottomTitles(xLabels,
                                flowMeter.type=="all-well"?"nothing":flowMeter.type=="one-well"?"clock":"date"),
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
              Padding(
                padding:  EdgeInsets.only(bottom: 30.h),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: yValues.length + 1,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        color: ColorPalette.lightGrey,
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text( state.oneWell.length==1? "تاریخ":"چاه", style: TextStyleP.f10Regular,textAlign: TextAlign.center)),
                            Expanded(flex: 2, child: Text("مجموع ساعات کارکرد پمپ", style: TextStyleP.f10Regular,textAlign: TextAlign.center)),
                          ],
                        ),
                      );
                    }else{

                      final item = flatList[index - 1];

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        decoration: BoxDecoration(border: BoxBorder.fromLTRB(bottom: BorderSide(color: ColorPalette.grey, width: 1))),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(item.name.toString().toPersianDigit(),textAlign: TextAlign.center)),
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