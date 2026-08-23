import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/report_flow_meter_status.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/params/flowmeter_params.dart';
import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/global_elevated_button.dart';
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
                      return Row(
                        children: [
                          GlobalElevatedButton(
                            backColor: state.selectedChartTab==1?ColorPalette.inverseBlue:ColorPalette.lightGrey,
                            borderRadius: 50,

                            widget: Text("امروز",style: TextStyle(color: ColorPalette.black),),
                            onTap:state.reportFlowMeterStatus is ReportFlowMeterLoading?null: () {
                              BlocProvider.of<StatusSummaryBloc>(context).add(ReportFlowMeter(FlowMeterParams(
                                type: 1,
                                ids:int.parse(info[6]),
                              )));
                            },),

                          SizedBox(width: 10.w),
                          GlobalElevatedButton(
                              borderRadius: 50,
                              backColor: state.selectedChartTab==6?ColorPalette.inverseBlue:ColorPalette.lightGrey,
                              widget: Text("هفته",style: TextStyle(color: ColorPalette.black),),
                              onTap:state.reportFlowMeterStatus is ReportFlowMeterLoading?null: () {
                                BlocProvider.of<StatusSummaryBloc>(context).add(ReportFlowMeter(FlowMeterParams(
                                  type: 6,
                                  ids:int.parse(info[6]),
                                )));
                              }),
                        ],
                      );
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

                        // ترکیب تمام yAxisها در یک لیست واحد برای محاسبه اسکیل دقیق (بدون تغییر مقادیر)
                        final List<dynamic> allYValues = [];
                        for (var series in seriesList) {
                          if (series.yAxis != null) {
                            for (var val in series.yAxis!) {
                              if (val != null) {
                                allYValues.add((val as num).toDouble());
                              }
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

                            if (indexInSeries != -1 && indexInSeries < yValues.length && yValues[indexInSeries] != null) {
                              double val = (yValues[indexInSeries] as num).toDouble();
                              spots.add(FlSpot(j.toDouble(), val));
                            }
                          }

                          if (spots.isNotEmpty) {
                            chartBars.add(
                                LineChartBarData(
                                  isCurved: true,
                                  preventCurveOverShooting: true, // جلوگیری از افتادن انحنا به زیر خط صفر (بسیار مهم)
                                  color: Constants().lineColors[i % Constants().lineColors.length],
                                  barWidth: 2.5,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  spots: spots,
                                )
                            );
                          }
                        }

                        // ۴. ساخت BarChartGroups برای تب ستونی / استک‌شده (BarChart) با پشتیبانی از مثبت و منفی
                        List<BarChartGroupData> chartGroups = [];
                        chartGroups = List.generate(xLabels.length, (index) {
                          final currentDate = xLabels[index];
                          List<BarChartRodStackItem> stackItems = [];
                          double positiveSum = 0;
                          double negativeSum = 0;

                          for (int i = 0; i < seriesList.length; i++) {
                            final currentSeries = seriesList[i];
                            final yValues = currentSeries.yAxis;
                            final xValues = currentSeries.xAxis;

                            if (yValues != null && xValues != null) {
                              final seriesIndex = xValues.indexOf(currentDate);
                              if (seriesIndex != -1 && seriesIndex < yValues.length && yValues[seriesIndex] != null) {
                                double yVal = (yValues[seriesIndex] as num).toDouble();
                                final color = Constants().lineColors[i % Constants().lineColors.length];

                                if (yVal != 0) {
                                  if (yVal > 0) {
                                    stackItems.add(
                                      BarChartRodStackItem(
                                        positiveSum,
                                        positiveSum + yVal,
                                        color,
                                      ),
                                    );
                                    positiveSum += yVal;
                                  } else {
                                    stackItems.add(
                                      BarChartRodStackItem(
                                        negativeSum,
                                        negativeSum + yVal,
                                        color,
                                      ),
                                    );
                                    negativeSum += yVal;
                                  }
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
                                toY: positiveSum > 0 ? positiveSum : 0,
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
                        // اعمال minY واقعی برای نمایش مقادیر منفی در پایین محور
                        final double chartMinY = (scale["minY"] != null && (scale["minY"] as num) < 0)
                            ? (scale["minY"] as num).toDouble()
                            : 0.0;

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
                                            handleBuiltInTouches: true,
                                            touchTooltipData: LineTouchTooltipData(
                                              getTooltipColor: (group) => const Color(0xFFF7F9FA),
                                              fitInsideHorizontally: true,
                                              fitInsideVertically: true,
                                              maxContentWidth: 250.w,
                                              // tooltipBorder: BorderSide(color: ColorPalette.grey),

                                              // اصلاح مهم: در LineChart باید یک لیست از LineTooltipItem برگردانید
                                              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                                if (touchedSpots.isEmpty) return [];

                                                // فقط اولین نقطه را مبنا قرار می‌دهیم تا کل لیست یک بار ساخته شود و تکرار نشود
                                                final spot = touchedSpots.first;
                                                final int xIndex = spot.x.toInt();
                                                if (xIndex < 0 || xIndex >= xLabels.length) return [];

                                                final String currentDate = xLabels[xIndex];

                                                List<TextSpan> spans = [];
                                                double totalSum = 0;

                                                // ۱. محاسبه مجموع کل مقادیر واقعی
                                                for (var series in seriesList) {
                                                  final yValues = series.yAxis;
                                                  final xValues = series.xAxis;
                                                  if (yValues != null && xValues != null) {
                                                    final sIndex = xValues.indexOf(currentDate);
                                                    if (sIndex != -1 && sIndex < yValues.length && yValues[sIndex] != null) {
                                                      totalSum += (yValues[sIndex] as num).toDouble();
                                                    }
                                                  }
                                                }
                                          // جدا کردن تاریخ و ساعت با فاصله و برداشتن بخش دوم (ساعت)
                                                final String timeLabel = currentDate.contains(" ")
                                                    ? currentDate.split(" ")[1].toString().toPersianDigit()
                                                    : currentDate.toString().toPersianDigit();

                                                spans.add(
                                                  TextSpan(
                                                    text: "ساعت: $timeLabel\n",
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );

                                                // ۳. حلقه برای جزئیات هر سری با مقادیر واقعی
                                                for (int i = 0; i < seriesList.length; i++) {
                                                  final series = seriesList[i];
                                                  final name = series.name ?? "بدون نام";
                                                  final yValues = series.yAxis;
                                                  final xValues = series.xAxis;

                                                  if (yValues != null && xValues != null) {
                                                    final sIndex = xValues.indexOf(currentDate);
                                                    if (sIndex != -1 && sIndex < yValues.length && yValues[sIndex] != null) {
                                                      final double val = (yValues[sIndex] as num).toDouble();
                                                      final color = Constants().lineColors[i % Constants().lineColors.length];
// ۱. فرمت کردن صحیح مقدار منفی
                                                      final String formattedVal = val < 0
                                                          ? "-${(-val).toStringAsFixed(1).toString().toPersianDigit()}"
                                                          : val.toStringAsFixed(1).toString().toPersianDigit();

                                          // ۲. اضافه کردن مقدار (سمت چپ)
                                                      spans.add(
                                                        TextSpan(
                                                          text: "\u200E$formattedVal  ",
                                                          style: const TextStyle(
                                                            color: Colors.black87,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      );

                                            // ۳. اضافه کردن نام (وسط / سمت راستِ مقدار)
                                                      spans.add(
                                                        TextSpan(
                                                          text: "$name ",
                                                          style: const TextStyle(
                                                            color: Colors.black87,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      );

                                                // ۴. اضافه کردن فقط یک دایره رنگی در سمت راستِ نام (انتهای خط)
                                                      spans.add(
                                                        TextSpan(
                                                          text: "●\n",
                                                          style: TextStyle(
                                                            color: color,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }

                                                // فرمت کردن مجموع کل با مدیریت عدد منفی
                                                final String formattedTotal = totalSum < 0
                                                    ? "-${(-totalSum).toStringAsFixed(1).toString().toPersianDigit()}"
                                                    : totalSum.toStringAsFixed(1).toString().toPersianDigit();

                                                spans.add(
                                                  const TextSpan(
                                                    text: "------------------------------\n",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );

                                            // اول مقدار (سمت چپ) و بعد برچسب «مجموع کل:» (سمت راست)
                                                spans.add(
                                                  TextSpan(
                                                    text: "\u200E$formattedTotal", // مقدار عدد (سمت چپ)
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );

                                                spans.add(
                                                  const TextSpan(
                                                    text: " :مجموع کل", // برچسب (سمت راست)
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );

                                                // برگرداندن لیست با طول مساوی تعداد نقاط، اما با این ترفند که فقط یک تول‌تیپ واحد و تمیز رندر شود
                                                return touchedSpots.map((s) {
                                                  if (s == spot) {
                                                    return LineTooltipItem(
                                                      textAlign: TextAlign.right,
                                                      "",
                                                      const TextStyle(),
                                                      children: spans,
                                                    );
                                                  }
                                                  return null; // بقیه نقاط خالی برگردانده شوند تا تکرار نشوند
                                                }).toList();
                                              },
                                            ),
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
                                              getTooltipColor: (group) => Color(0xFFF7F9FA),
                                              fitInsideHorizontally: true,
                                              fitInsideVertically: true,
                                              maxContentWidth: 250.w,
                                              // tooltipBorder: BorderSide(color: ColorPalette.grey),
                                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                final int xIndex = group.x.toInt();
                                                if (xIndex < 0 || xIndex >= xLabels.length) return null;

                                                final String currentDate = xLabels[xIndex];

                                                List<TextSpan> spans = [];
                                                double totalSum = 0;

                                                // ۱. محاسبه مجموع کل مقادیر واقعی
                                                for (var series in seriesList) {
                                                  final yValues = series.yAxis;
                                                  final xValues = series.xAxis;
                                                  if (yValues != null && xValues != null) {
                                                    final sIndex = xValues.indexOf(currentDate);
                                                    if (sIndex != -1 && sIndex < yValues.length && yValues[sIndex] != null) {
                                                      totalSum += (yValues[sIndex] as num).toDouble();
                                                    }
                                                  }
                                                }

                                                final String weekDayName = Constants().weekDayNames[xIndex].name;

                                                spans.add(
                                                  TextSpan(
                                                    text: " $weekDayName\n",
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );

                                                // ۳. حلقه برای جزئیات هر سری با مقادیر واقعی
                                                for (int i = 0; i < seriesList.length; i++) {
                                                  final series = seriesList[i];
                                                  final name = series.name ?? "بدون نام";
                                                  final yValues = series.yAxis;
                                                  final xValues = series.xAxis;

                                                  if (yValues != null && xValues != null) {
                                                    final sIndex = xValues.indexOf(currentDate);
                                                    if (sIndex != -1 && sIndex < yValues.length && yValues[sIndex] != null) {
                                                      final double val = (yValues[sIndex] as num).toDouble();
                                                      final color = Constants().lineColors[i % Constants().lineColors.length];

                                                      spans.add(
                                                        TextSpan(
                                                          text: "$name: ${val.toStringAsFixed(1).toString().toPersianDigit()}  ",
                                                          style: const TextStyle(
                                                            color: Colors.black87,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      );

                                                      spans.add(
                                                        TextSpan(
                                                          text: "●\n",
                                                          style: TextStyle(
                                                            color: color,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }

                                                // ۴. اضافه کردن خط مجموع کل در انتها
                                                spans.add(
                                                  const TextSpan(
                                                    text: "------------------------------\n",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                );
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

                                                return BarTooltipItem(
                                                  textAlign: TextAlign.right,
                                                  "",
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
