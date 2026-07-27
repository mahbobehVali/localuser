import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_command_status.dart';

class PumpHoursChartWidget extends StatelessWidget {
  const PumpHoursChartWidget({super.key});

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
            return const Center(child: Text("دیتایی وجود ندارد"));
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
                          borderData: FlBorderData(border: const Border(bottom: BorderSide(), left: BorderSide())),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: Constants().axisBottomTitles(xLabels,
                                flowMeter.type=="all-well"?"nothing":flowMeter.type=="one-well"?"clock":"date"),
                            leftTitles: Constants().leftTitles(
                              interval: scale["maxY"]! > 1000 ? 65.w : 40.w,
                              scale: scale['step'] == 0 ? 10 : scale['step']!,
                            ),
                          ),
                          barGroups: chartGroups,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text("جدول اطلاعات تکمیلی نمودار", style: TextStyleP.f12Regular),
              ListView.builder(
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
                          Expanded(flex: 2, child: Text("تاریخ", style: TextStyleP.f10Regular)),
                          Expanded(flex: 3, child: Text("مجموع ساعات کارکرد پمپ", style: TextStyleP.f10Regular)),
                        ],
                      ),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    decoration: BoxDecoration(border: BoxBorder.fromLTRB(bottom: BorderSide(color: ColorPalette.grey, width: 1))),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(xLabels[index - 1])),
                        Expanded(flex: 3, child: Text('\u200E${yValues[index - 1].toString().toPersianDigit()}')),
                      ],
                    ),
                  );
                },
              )
            ],
          );
        }
        if (status is ReportCommandLoading) return const Center(child: CircularProgressIndicator());
        if (status is ReportCommandError) return Center(child: Text(status.error));
        return const SizedBox.shrink();
      },
    );
  }
}