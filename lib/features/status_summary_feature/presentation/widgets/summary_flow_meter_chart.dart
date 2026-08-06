import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';

import '../../../../common/params/flowmeter_params.dart';
import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/shimmer_class.dart';
import '../../../../config/texts_style.dart';
import '../bloc/status_summary_bloc/report_flowmeter_status.dart';
import '../bloc/status_summary_bloc/status_summary_bloc.dart';

class SummaryFlowMeterChart extends StatelessWidget {
  const SummaryFlowMeterChart({
    super.key,
    required this.info,
  });

  final List<dynamic> info;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white
        ),
        child: Padding(padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("روند مصرف آب چاه‌ها",style: TextStyleP.f12Regular),
                  BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                    buildWhen: (previous, current) =>
                    current.selectedChartTab!=previous.selectedChartTab,
                    builder: (context, state) {
                      return SegmentedButton(

                          onSelectionChanged: (Set<int> newSelected) {
                            BlocProvider.of<StatusSummaryBloc>(context).add(ReportFlowMeter(FlowMeterParams(
                              type: newSelected.first,
                              ids:[int.parse(info[6])],
                            )));

                          },
                          segments: [
                            ButtonSegment(value: 0,label: Text("امروز")),
                            ButtonSegment(value: 6,label: Text("هفته")),

                          ], selected:{state.selectedChartTab});
                    },
                  ),

                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:20),
                child: SizedBox(
                  height: 300.h,
                  child: BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                    builder: (context, state) {
                      if (state.reportFlowMeterStatus is SummaryFlowMeterSuccess) {
                        final successState = state.reportFlowMeterStatus as SummaryFlowMeterSuccess;
                        final seriesList = successState.flowMeterEntity.list.series;

                        // ۱. بررسی خالی بودن کل سری‌ها
                        final bool isAllEmpty = seriesList?.every(
                              (element) => element.yAxis?.isEmpty ?? true,
                        ) ?? true;

                        if (isAllEmpty || seriesList == null || seriesList.isEmpty) {
                          return const Center(child: Text("دیتایی وجود ندارد"));
                        }

                        // ترکیب تمام yAxisها در یک لیست واحد برای محاسبه اسکیل دقیق
                        final List<dynamic> allYValues = [];
                        for (var series in seriesList) {
                          if (series.yAxis != null) {
                            allYValues.addAll(series.yAxis!);
                          }
                        }

                        final scale = Constants().getScale(allYValues);

                        List<LineChartBarData> chartBars = [];
                        final validSeries = seriesList.firstWhere(
                              (element) => element.xAxis != null && element.yAxis != null &&
                              element.yAxis!.isNotEmpty,
                          orElse: () => seriesList.first,
                        );
                        final xLabels = validSeries.xAxis;

                        for (int i = 0; i < seriesList.length; i++) {
                          final currentSeries = seriesList[i];
                          final yValues = currentSeries.yAxis;

                          if (yValues == null || yValues.isEmpty) continue;

                          List<FlSpot> spots = [];
                          for (int j = 0; j < xLabels!.length; j++) {
                            // مراقبت از اینکه مقدار y نال نباشه یا طول آرایه فراتر نره
                            if (j < yValues.length && yValues[j] != null) {
                              spots.add(FlSpot(j.toDouble(), yValues[j].toDouble()));
                            }
                          }

                          // اضافه کردن خط تولید شده به لیست خطوط
                          if (spots.isNotEmpty) {
                            chartBars.add(
                              LineChartBarData(

                                isCurved: true,
                                // انتخاب رنگ بر اساس اندیس (اگر تعداد خطوط بیشتر از رنگ‌ها شد، از اول چرخ می‌خوره)
                                color: Constants().lineColors[i % Constants().lineColors.length],
                                barWidth: 2.5,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                spots: spots,
                              ),
                            );
                          }
                        }
                        double chartWidth = xLabels!.length * 40.0;
                        double screenWidth = MediaQuery.of(context).size.width;
                        if (chartWidth < screenWidth) {
                          chartWidth = screenWidth; // اگر دیتا کم بود، چارت کل صفحه را پر کند
                        }

                        return Column(
                          children: [
                            Expanded(
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: chartWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: LineChart(
                                        LineChartData(
                                          extraLinesData: ExtraLinesData(
                                            horizontalLines: Constants().generateHorizontalLines((scale['step'] as num).toDouble(), scale["maxY"]!,scale["minY"]!),
                                          ),
                                          borderData: FlBorderData(
                                            show: true,
                                            border: const Border(bottom: BorderSide(), left: BorderSide()),
                                          ),
                                          lineTouchData: LineTouchData(
                                            touchTooltipData: LineTouchTooltipData(
                                              getTooltipColor: (LineBarSpot touchedSpot) => ColorPalette.lightGrey,

                                            ),
                                            handleBuiltInTouches: true,
                                          ),
                                          titlesData: FlTitlesData(
                                            bottomTitles: Constants().axisBottomTitles(xLabels,state.selectedChartTab==0? "day":"week"),
                                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

                                            leftTitles: Constants().leftTitles(interval:scale["maxY"]! > 1000 ? 65.w : 40.w,
                                                scale:  scale['step'] == 0 ? 10 : scale['step']!),
                                          ),
                                          gridData: FlGridData(show: false),
                                          lineBarsData: chartBars,
                                          maxY: scale["maxY"],
                                          minY: scale["minY"],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              alignment: WrapAlignment.center,
                              children: List.generate(seriesList.length, (index) {
                                final currentSeries = seriesList[index];

                                final color = Constants().lineColors[index % Constants().lineColors.length];

                                // دریافت نام سری
                                final String seriesName = currentSeries.name ?? "خط ${index + 1}";

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.rectangle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      seriesName,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ],
                        );
                      }
                      else if (state.reportFlowMeterStatus is SummaryFlowMeterLoading) {
                        return state.selectedChartTab == 0
                            ?  ShimmerClass.lineChartShimmer()
                            :  ShimmerClass.barChartShimmer() ;
                      } else if (state.reportFlowMeterStatus is SummaryFlowMeterError) {
                        SummaryFlowMeterError reportFlowMeterError = state.reportFlowMeterStatus as SummaryFlowMeterError;
                        return Center(child: Text(reportFlowMeterError.error));
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),)
    );
  }
}
