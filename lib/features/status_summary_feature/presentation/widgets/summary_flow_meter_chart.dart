import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

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
                  Text("روند مصرف آب چاه‌ها",style: TextStyleP.f14Medium),
                  BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                    buildWhen: (previous, current) =>
                    current.selectedChartTab!=previous.selectedChartTab,
                    builder: (context, state) {
                      return SegmentedButton(

                          onSelectionChanged: (Set<int> newSelected) {
                            BlocProvider.of<StatusSummaryBloc>(context).add(ReportFlowMeter(FlowMeterParams(
                              type: newSelected.first,
                              ids:int.parse(info[6]),
                            )));

                          },
                          segments: [
                            ButtonSegment(value: 1,label: Text("امروز")),
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
                          return Constants.noData();
                        }

                        // ۲. استخراج تمام تاریخ‌های یکتا (xAxis) از کل سری‌ها و مرتب‌سازی آن‌ها
                        final Set<String> allDatesSet = {};
                        for (var series in seriesList) {
                          if (series.xAxis != null) {
                            allDatesSet.addAll(series.xAxis!.map((e) => e.toString()));
                          }
                        }
                        final List<String> xLabels = allDatesSet.toList()..sort();

                        if (xLabels.isEmpty) {
                          return Constants.noData();
                        }

                        // متد کمکی برای اعمال قوانین تبدیل مقدار (منفی -> ۳۰، صفر یا نال -> ۱۰)
                        double getMappedValue(dynamic rawValue) {
                          if (rawValue == null) return 10.0;
                          final double val = (rawValue as num).toDouble();
                          if (val < 0) {
                            return 30.0;
                          } else if (val == 0) {
                            return 10.0;
                          }
                          return val;
                        }

                        // ترکیب تمام yAxisها در یک لیست واحد برای محاسبه اسکیل دقیق
                        final List<dynamic> allYValues = [];
                        for (var series in seriesList) {
                          if (series.yAxis != null) {
                            for (var val in series.yAxis!) {
                              allYValues.add(getMappedValue(val));
                            }
                          }
                        }

                        final scale = Constants().getScale(allYValues);

                        // ۳. ساخت LineChartBars برای تب خطی (LineChart)
                        List<LineChartBarData> chartBars = [];
                        for (int i = 0; i < seriesList.length; i++) {
                          final currentSeries = seriesList[i];
                          final yValues = currentSeries.yAxis;
                          final xValues = currentSeries.xAxis;

                          if (yValues == null || yValues.isEmpty || xValues == null) continue;

                          List<FlSpot> spots = [];
                          for (int j = 0; j < xLabels.length; j++) {
                            final date = xLabels[j];
                            final indexInSeries = xValues.indexOf(date);

                            if (indexInSeries != -1 && indexInSeries < yValues.length) {
                              double finalVal = getMappedValue(yValues[indexInSeries]);
                              spots.add(FlSpot(j.toDouble(), finalVal));
                            }
                          }

                          if (spots.isNotEmpty) {
                            chartBars.add(
                              LineChartBarData(
                                isCurved: true,
                                color: Constants().lineColors[i % Constants().lineColors.length],
                                barWidth: 2.5,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                spots: spots,
                              ),
                            );
                          }
                        }

                        // ۴. ساخت BarChartGroups برای تب ستونی / استک‌شده (BarChart)
                        List<BarChartGroupData> chartGroups = [];
                        chartGroups = List.generate(xLabels.length, (index) {
                          final currentDate = xLabels[index];
                          List<BarChartRodStackItem> stackItems = [];
                          double positiveSum = 0;

                          for (int i = 0; i < seriesList.length; i++) {
                            final currentSeries = seriesList[i];
                            final yValues = currentSeries.yAxis;
                            final xValues = currentSeries.xAxis;

                            if (yValues != null && xValues != null) {
                              final seriesIndex = xValues.indexOf(currentDate);
                              if (seriesIndex != -1 && seriesIndex < yValues.length) {
                                double yVal = getMappedValue(yValues[seriesIndex]);

                                if (yVal > 0) {
                                  final color = Constants().lineColors[i % Constants().lineColors.length];
                                  stackItems.add(
                                    BarChartRodStackItem(
                                      positiveSum,
                                      positiveSum + yVal,
                                      color,
                                    ),
                                  );
                                  positiveSum += yVal;
                                }
                              }
                            }
                          }

                          if (stackItems.isEmpty) {
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

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: positiveSum,
                                rodStackItems: stackItems,
                                width: 12,
                                borderRadius: BorderRadius.zero,
                              ),
                            ],
                          );
                        });

                        // ۵. تنظیم عرض چارت بر اساس تعداد داده‌ها
                        double chartWidth = xLabels.length * 60.0;
                        double screenWidth = MediaQuery.of(context).size.width;
                        if (chartWidth < screenWidth) {
                          chartWidth = screenWidth;
                        }

                        final double chartMaxY = (scale["maxY"] as num?)?.toDouble() ?? 100.0;
                        final double chartMinY = 0.0;

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
                                      child: state.selectedChartTab == 1
                                          ? LineChart(
                                        LineChartData(
                                          extraLinesData: ExtraLinesData(
                                            horizontalLines: Constants().generateHorizontalLines(
                                              (scale['step'] as num).toDouble(),
                                              chartMaxY,
                                              chartMinY,
                                            ),
                                          ),
                                          borderData: FlBorderData(
                                            show: true,
                                            border: Border(
                                              bottom: BorderSide(color: ColorPalette.lightGrey),
                                            ),
                                          ),
                                          lineTouchData: LineTouchData(
                                            touchTooltipData: LineTouchTooltipData(
                                              getTooltipColor: (LineBarSpot touchedSpot) =>
                                              ColorPalette.lightGrey,
                                              fitInsideHorizontally: true,
                                              fitInsideVertically: true,
                                            ),
                                            handleBuiltInTouches: true,
                                          ),
                                          titlesData: FlTitlesData(
                                            bottomTitles: Constants().axisBottomTitles(xLabels, "day"),
                                            rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                            leftTitles: Constants().leftTitles(
                                              interval: chartMaxY > 1000 ? 65.w : 40.w,
                                              scale: scale['step'] == 0 ? 10 : (scale['step'] as num).toDouble(),
                                            ),
                                          ),
                                          gridData: const FlGridData(show: false),
                                          lineBarsData: chartBars,
                                          maxY: chartMaxY,
                                          minY: chartMinY,
                                        ),
                                      )
                                          : BarChart(
                                        BarChartData(
                                          extraLinesData: ExtraLinesData(
                                            horizontalLines: Constants().generateHorizontalLines(
                                              (scale['step'] as num).toDouble(),
                                              chartMaxY,
                                              chartMinY,
                                            ),
                                          ),
                                          maxY: chartMaxY,
                                          minY: chartMinY,
                                          alignment: BarChartAlignment.spaceAround,
                                          gridData: FlGridData(
                                            show: false,
                                            verticalInterval: (scale['step'] as num?)?.toDouble() ?? 1,
                                            getDrawingHorizontalLine: (value) {
                                              return const FlLine(
                                                strokeWidth: 1,
                                                color: Colors.grey,
                                              );
                                            },
                                          ),
                                          borderData: FlBorderData(
                                            border: Border(
                                              bottom: BorderSide(color: ColorPalette.lightGrey),
                                            ),
                                          ),
                                          barTouchData: BarTouchData(
                                            handleBuiltInTouches: true,
                                            touchTooltipData: BarTouchTooltipData(
                                              getTooltipColor: (group) => ColorPalette.white,
                                              fitInsideHorizontally: true,
                                              fitInsideVertically: true,
                                              tooltipBorder: BorderSide(color: ColorPalette.grey),
                                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                final int xIndex = group.x.toInt();
                                                if (xIndex < 0 || xIndex >= xLabels.length) return null;

                                                final String currentDate = xLabels[xIndex];

                                                List<TextSpan> spans = [];
                                                double totalSum = 0;

                                                // ۱. محاسبه مجموع کل مقادیر ابتدا (تا رقم نهایی درست دربیاد)
                                                for (var series in seriesList) {
                                                  final yValues = series.yAxis;
                                                  final xValues = series.xAxis;
                                                  if (yValues != null && xValues != null) {
                                                    final sIndex = xValues.indexOf(currentDate);
                                                    if (sIndex != -1 && sIndex < yValues.length) {
                                                      totalSum += getMappedValue(yValues[sIndex]);
                                                    }
                                                  }
                                                }

                                                // ۲. اضافه کردن خط تاریخ با رنگ خاکستری (طوسی)
                                                spans.add(
                                                  TextSpan(
                                                    text: "تاریخ: ${currentDate.toString().toPersianDigit()}\n-------------------\n",
                                                    style: const TextStyle(
                                                      color: Colors.black87, // رنگ طوسی برای تاریخ
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );



                                                // ۴. حلقه برای اضافه کردن جزئیات هر سری
                                                for (int i = 0; i < seriesList.length; i++) {
                                                  final series = seriesList[i];
                                                  final name = series.name ?? "بدون نام";
                                                  final yValues = series.yAxis;
                                                  final xValues = series.xAxis;

                                                  if (yValues != null && xValues != null) {
                                                    final sIndex = xValues.indexOf(currentDate);
                                                    if (sIndex != -1 && sIndex < yValues.length) {
                                                      final double val = getMappedValue(yValues[sIndex]);
                                                      // (اختیاری) اگر می‌خواهید رنگ هر متن هماهنگ با رنگ چارت خودش باشد، می‌توانید از رنگ سری استفاده کنید
                                                      final color = Constants().lineColors[i % Constants().lineColors.length];

                                                      spans.add(
                                                        TextSpan(
                                                          text: "$name: ${val.toStringAsFixed(1).toString().toPersianDigit()}\n",
                                                          style: TextStyle(
                                                            color: color, // یا Colors.black87 اگر رنگ ثابت می‌خواهید
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                                // ۳. اضافه کردن خط مجموع کل
                                                spans.add(
                                                  TextSpan(
                                                    text: "مجموع کل: ${totalSum.toStringAsFixed(1).toString().toPersianDigit()}",
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
                                                // حذف خط اضافه آخر اگر وجود داشته باشد
                                                if (spans.isNotEmpty) {
                                                  // حذف \n آخر آخرین اسپم برای جلوگیری از پدینگ اضافی
                                                }

                                                return BarTooltipItem(
                                                  "", // متن اصلی خالی گذاشته می‌شود چون از children استفاده می‌کنیم
                                                  const TextStyle(),
                                                  children: spans,
                                                );
                                              },
                                            ),
                                          ),
                                          titlesData: FlTitlesData(
                                            bottomTitles: Constants().axisBottomTitles(xLabels, "week"),
                                            rightTitles: const AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                            topTitles: const AxisTitles(
                                              sideTitles: SideTitles(showTitles: false),
                                            ),
                                            leftTitles: Constants().leftTitles(
                                              interval: chartMaxY > 1000 ? 65.w : 40.w,
                                              scale: scale['step'] == 0 ? 10 : (scale['step'] as num).toDouble(),
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
                            // ۶. راهنمای رنگ‌ها (Legend) پایین چارت
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              alignment: WrapAlignment.center,
                              children: List.generate(seriesList.length, (index) {
                                final currentSeries = seriesList.getRange; // اصلاح سیف
                                final currentSeriesItem = seriesList[index];
                                final color = Constants().lineColors[index % Constants().lineColors.length];
                                final String seriesName = currentSeriesItem.name ?? "خط ${index + 1}";

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
                        return ShimmerClass.lineChartShimmer();
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
