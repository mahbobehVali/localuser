import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/socket_repository.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_data_entity.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/wells_list_usecase.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/flow_meter_usecase.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/get_program_usecase.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/well_work_usecase.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/flowmeter_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/flowmeter_today_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/pump_performance_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/well_detail_bloc.dart';
import 'package:mahaliii/features/well_feature/presentation/screens/widgets/program_widget.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/global_snackbar.dart';
import '../../../../common/widgets/icon_container.dart';
import '../../../../common/widgets/indicator_widget.dart';
import '../../../../common/widgets/show_dialogs.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../../../../locator.dart';
import '../../domain/repository/wells_repository.dart';
import '../../domain/usecase/alert_count_usecase.dart';
import '../bloc/well_detail_bloc/finger_status.dart';
import '../bloc/well_detail_bloc/on_off_status.dart';
import '../bloc/well_detail_bloc/week_well_work_status.dart';

class WellDetailScreen extends StatefulWidget {
  const WellDetailScreen({super.key, required this.wellsDataEntity});

  final WellsDataEntity wellsDataEntity;

  @override
  State<WellDetailScreen> createState() => _WellDetailScreenState();
}

class _WellDetailScreenState extends State<WellDetailScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  List<PieChartSectionData> showingSections({dynamic on, dynamic off}) {
    return List.generate(2, (i) {
      // final isTouched = i == touchedIndex;
      // final fontSize = isTouched ? 25.0 : 16.0;
      // final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return switch (i) {
        0 =>
            PieChartSectionData(
              color: ColorPalette.darkBlue,
              value: (on ?? 0).toDouble(),
              title: '',
              titleStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            ),
        1 =>
            PieChartSectionData(
              color: Colors.grey.shade400,
              value: (off ?? 0).toDouble(),
              title: '',
              titleStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: shadows,
              ),
            ),
        _ => throw SizedBox(),
      };
    });
  }
  bool builtOnce = false;

  late WellDetailBloc _bloc;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    print("widget.wellsDataEntity.id!${widget.wellsDataEntity.id!}");

    final socketRepository = locator<SocketRepository>();

    socketRepository.initAndConnect(
      widget.wellsDataEntity.pin ?? "",
    );

    _bloc = WellDetailBloc(
      locator<WellsRepository>(),
      locator<WellWorkHourUseCase>(),
      locator<WellFlowMeterUseCase>(),
      locator<WellsListUseCase>(),
      locator<GetProgramUseCase>(),
      socketRepository,
      locator<AlertCountUseCase>(),
    );

    _bloc
      ..add(
        WellWorkHourStart(
          FlowMeterParams(
            type: 2,
            ids: [widget.wellsDataEntity.deviceId!],
          ),
        ),
      )
      ..add(
        WellPerformance(
          FlowMeterParams(
            type: 2,
            time: 2,
            ids: [widget.wellsDataEntity.deviceId!],
          ),
        ),
      )..add(
        FlowMeterEvent(
          FlowMeterParams(
            type: 0,
            ids: [widget.wellsDataEntity.deviceId!],
          ),
        ),
      )
      ..add(
        GetProgram(widget.wellsDataEntity.id!),
      )
      ..add(
        FirstSwitch(
          widget.wellsDataEntity.statusWell == 1,
        ),
      )
      ..add(
        ChangeUserLocalId(
          widget.wellsDataEntity.userLocalId,
        ),
      );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_bloc.state.fingerStatus is FingerLoading ||
            _bloc.state.fingerStatus is FingerRequestAccepted) {
          _bloc.add(StatusEvent(0));
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _bloc.close();
    super.dispose();
  }

  void _startProcess() {
    _controller
      ..reset()
      ..forward();

    _bloc.add(
      FingerSocketEvent(
        widget.wellsDataEntity.pin!,
        widget.wellsDataEntity.deviceId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: _bloc,
      // create: (context) {
      //   WellDetailBloc wellDetailBloc = WellDetailBloc(
      //     locator<WellsRepository>(),
      //     locator<WellWorkHourUseCase>(),
      //     locator<WellFlowMeterUseCase>(),
      //     locator<WellsListUseCase>(),
      //     locator<GetProgramUseCase>(),
      //     locator<SocketRepository>(),
      //     locator<AlertCountUseCase>(),
      //   );
      //   wellDetailBloc..
      //   add(WellWorkHourStart(FlowMeterParams(
      //       type: 2,
      //       ids: [widget.wellsDataEntity.deviceId!]
      //   )))
      //     ..add(WellPerformance(FlowMeterParams(
      //         type: 2,
      //         time: 2,
      //         ids: [widget.wellsDataEntity.deviceId!]
      //   )))..add(GetProgram(widget.wellsDataEntity.id!))..
      //   add(FirstSwitch(widget.wellsDataEntity.statusWell==1?true:false))..
      //   add(ChangeUserLocalId(widget.wellsDataEntity.userLocalId));
      //   // ..add(AlertCountStart(
      //   //   FlowMeterParams(
      //   //     time: 2,
      //   //     ids: [12]
      //   //   )
      //   // )
      //   // )
      //       ;
      //   return wellDetailBloc;
      // },
      child: Scaffold(
          body:  Padding(
            padding:  EdgeInsets.only(left: 16.w,right: 16.w,top:50.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<WellDetailBloc, WellDetailState>(
                        builder: (context, state) {
                          return SegmentedButton(
                              style: SegmentedButton.styleFrom(
                                  backgroundColor: ColorPalette.lightGrey,
                              ),


                              onSelectionChanged: (Set<int> newSelected) {
                                BlocProvider.of<WellDetailBloc>(context).add(ChangeWellTab(newSelected.first));

                              },
                              segments: [
                                ButtonSegment(value: 0,label: Text("وضعیت کلی")),
                                ButtonSegment(value: 1,label: Text("کنترل چاه")),

                              ], selected:{state.selectedWellTab});
                        },
                      ),
                      IconButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          side: WidgetStatePropertyAll(
                            BorderSide(),
                          ),
                        ),
                        icon: const Icon(Icons.navigate_next),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 26.h),
                  BlocSelector<WellDetailBloc, WellDetailState, int>(
                    selector: (state) => state.selectedWellTab,


                    builder: (context, selectedTab) {
                    return selectedTab==0?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "خلاصه وضعیت چاه ${widget.wellsDataEntity.wellName}",
                          style: TextStyleP.f16Medium,
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical: 8.h),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("میزان حجم آب عبوری دبی سنج", style: TextStyleP.f12Regular),
                                      BlocBuilder<WellDetailBloc, WellDetailState>(
                                        buildWhen: (previous, current) =>
                                        current.selectedChartVolumeTab != previous.selectedChartVolumeTab,
                                        builder: (context, state) {
                                          return SegmentedButton(
                                            onSelectionChanged: (Set<int> newSelected) {
                                              BlocProvider.of<WellDetailBloc>(context).add(
                                                FlowMeterEvent(
                                                  FlowMeterParams(
                                                    type: newSelected.first,
                                                    ids: [widget.wellsDataEntity.deviceId!],
                                                  ),
                                                ),
                                              );
                                            },
                                            segments: const [
                                              ButtonSegment(value: 0, label: Text("امروز")),
                                              ButtonSegment(value: 6, label: Text("هفته")),
                                            ],
                                            selected: {state.selectedChartVolumeTab},
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                  BlocBuilder<WellDetailBloc, WellDetailState>(
                                    builder: (context, state) {
                                      final status = state.flowMeterStatus;

                                      if (status is FlowMeterLoading) {
                                        return state.selectedChartVolumeTab == 0
                                            ?  ShimmerClass.lineChartShimmer()
                                            :  ShimmerClass.barChartShimmer() ;
                                      }

                                      if (status is FlowMeterError) {
                                        return Container(
                                          height: 250,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.error_outline, color: Colors.red, size: 40),
                                              const SizedBox(height: 8),
                                              Text(
                                                status.error,
                                                style: TextStyleP.f12Regular.copyWith(color: Colors.red),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 12),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  context.read<WellDetailBloc>().add(
                                                    FlowMeterEvent(
                                                      FlowMeterParams(
                                                        type: state.selectedChartVolumeTab,
                                                        ids: [widget.wellsDataEntity.deviceId!],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(Icons.refresh, size: 18),
                                                label: const Text("تلاش مجدد"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      // بررسی صحت دریافت داده‌های API اولیه
                                      if (status is! FlowMeterSuccess) {
                                        if (status is FlowMeterLoading) return const Center(child: CircularProgressIndicator());
                                        if (status is FlowMeterEmpty) return Constants.noData();
                                        if (status is FlowMeterError) return Center(child: Text(status.error));
                                        return const SizedBox.shrink();
                                      }

                                      final flowMeter = status.wellFlowMeterEntity?.list;
                                      if (flowMeter == null || flowMeter.xAxis == null || flowMeter.yAxis == null) {
                                        return Constants.noData();
                                      }

                                      // ۱. ساخت کپی مجزا از داده‌های API برای جلوگیری از تغییر مستقیم State
                                      final List<String> xLabels = List<String>.from(flowMeter.xAxis!);
                                      final List<dynamic> yValues = flowMeter.yAxis!.map((e) => (e ?? 0).toDouble()).toList();

                                      // ۲. اعمال دیتای سوکت *فقط* اگر تب روی «امروز» (0) باشد
                                      if (state.selectedChartVolumeTab == 0 && state.flowMeterTodayStatus is FlowMeterTodaySuccess) {
                                        final flowMeterTodaySuccess = state.flowMeterTodayStatus as FlowMeterTodaySuccess;
                                        final todayEntity = flowMeterTodaySuccess.wellFlowMeterTodayOneEntity;

                                        if (todayEntity != null && todayEntity.xAxis != null && todayEntity.yAxis != null) {
                                          final socketX = todayEntity.xAxis.toString();
                                          final socketY = todayEntity.yAxis!.toDouble();

                                          if (xLabels.isNotEmpty && xLabels.last == socketX) {
                                            final lastY = yValues.last;
                                            if (lastY != socketY) {
                                              yValues[yValues.length - 1] = (lastY + socketY) / 2;
                                            }
                                          } else {
                                            xLabels.add(socketX);
                                            yValues.add(socketY);
                                          }
                                        }
                                      }

                                      if (xLabels.isEmpty || yValues.isEmpty) {
                                        return Constants.noData();
                                      }

                                      // ۳. محاسبه مقیاس بر اساس داده‌های نهایی (شامل سوکت در صورت انتخاب تب امروز)
                                      final scale = Constants().getScale(yValues);

                                      // ۴. آماده‌سازی داده‌های نمودار خطی
                                      final List<FlSpot> spots = List.generate(
                                        yValues.length,
                                            (j) => FlSpot(j.toDouble(), yValues[j]),
                                      );

                                      // ۵. آماده‌سازی داده‌های نمودار میله‌ای
                                      final List<BarChartGroupData> chartGroups = List.generate(yValues.length, (index) {
                                        return BarChartGroupData(
                                          x: index,
                                          barRods: [
                                            BarChartRodData(
                                              toY: yValues[index],
                                              color: ColorPalette.darkBlue,
                                              width: 12,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ],
                                        );
                                      });

                                      final double columnWidth = 80.0;
                                      final double calculatedChartWidth = (xLabels.length * columnWidth).clamp(350.0, 2000.0);

                                      return Column(
                                        children: [
                                          Directionality(
                                            textDirection: TextDirection.ltr,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                width: calculatedChartWidth,
                                                height: 300,
                                                padding: const EdgeInsets.only(top: 40, right: 18.0, bottom: 10),
                                                child: state.selectedChartVolumeTab == 0
                                                    ? LineChart(
                                                  LineChartData(
                                                    extraLinesData: ExtraLinesData(
                                                      horizontalLines: Constants().generateHorizontalLines(
                                                        (scale['step'] as num).toDouble(),
                                                        scale["maxY"]!,
                                                        scale["minY"]!,
                                                      ),
                                                    ),
                                                    borderData: FlBorderData(
                                                      show: true,
                                                      border:  Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                                                    ),
                                                    titlesData: FlTitlesData(
                                                      bottomTitles: Constants().axisBottomTitles(xLabels, "day"),
                                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      leftTitles: Constants().leftTitles(
                                                        interval: scale["maxY"]! > 1000 ? 55.w : 40.w,
                                                        scale: scale['step'] == 0 ? 10 : scale['step']!,
                                                      ),
                                                    ),
                                                    gridData: const FlGridData(show: false),
                                                    lineTouchData: LineTouchData(
                                                      touchTooltipData: LineTouchTooltipData(
                                                        getTooltipColor: (LineBarSpot touchedSpot) => ColorPalette.lightGrey,
                                                        fitInsideHorizontally: true, // جلوگیری از بیرون زدن افقی از چپ/راست
                                                        fitInsideVertically: true,   // جلوگیری از بیرون زدن عمودی از بالا/پایین
                                                      ),
                                                      handleBuiltInTouches: true,
                                                    ),
                                                    lineBarsData: [
                                                      LineChartBarData(
                                                        preventCurveOverShooting: true,
                                                        preventCurveOvershootingThreshold: 0,
                                                        dotData: const FlDotData(show: false),
                                                        isCurved: true,
                                                        // belowBarData: BarAreaData(
                                                        //   show: true,
                                                        //   gradient: LinearGradient(
                                                        //     colors: [
                                                        //       ColorPalette.darkBlue.withValues(alpha: 0.9),
                                                        //       ColorPalette.darkBlue.withValues(alpha: 0.5),
                                                        //     ],
                                                        //     begin: Alignment.topCenter,
                                                        //     end: Alignment.bottomCenter,
                                                        //   ),
                                                        // ),
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
                                                )
                                                    : BarChart(
                                                  BarChartData(
                                                    extraLinesData: ExtraLinesData(
                                                      horizontalLines: Constants().generateHorizontalLines(
                                                        (scale['step'] as num).toDouble(),
                                                        scale["maxY"]!,
                                                        scale["minY"]!,
                                                      ),
                                                    ),
                                                    maxY: scale['maxY'],
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
                                                    barTouchData: BarTouchData(
                                                        handleBuiltInTouches: true,
                                                        touchTooltipData: BarTouchTooltipData(
                                                          getTooltipColor: (group) => ColorPalette.lightGrey,
                                                          fitInsideHorizontally: true, // جلوگیری از بیرون زدن افقی از چپ/راست
                                                          fitInsideVertically: true,   // جلوگیری از بیرون زدن عمودی از بالا/پایین
                                                      )
                                                    ),

                                                    borderData: FlBorderData(
                                                      border: const Border(bottom: BorderSide(), left: BorderSide()),
                                                    ),
                                                    titlesData: FlTitlesData(
                                                      show: true,
                                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      bottomTitles: Constants().axisBottomTitles(xLabels, "nothing"),
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

                                          SizedBox(height: 16.h),
                                        ],
                                      );



                                    },
                                  ),
                                ],
                              ),
                            )
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("ساعات فعالیت پمپ",style: TextStyleP.f12Regular,),
                                      BlocBuilder<WellDetailBloc, WellDetailState>(
                                        buildWhen: (previous, current) =>
                                        current.selectedChartTab!=previous.selectedChartTab,
                                        builder: (context, state) {
                                          return SegmentedButton(

                                              onSelectionChanged: (Set<int> newSelected) {
                                                BlocProvider.of<WellDetailBloc>(context).add(
                                                    WellWorkHourStart(FlowMeterParams(
                                                  type: newSelected.first,
                                                  ids:[widget.wellsDataEntity.deviceId!],
                                                )));

                                              },
                                              segments: [
                                                ButtonSegment(value: 0,label: Text("امروز")),
                                                ButtonSegment(value: 2,label: Text("هفته")),

                                              ], selected:{state.selectedChartTab});
                                        },
                                      )
                                    ],
                                  ),
                                  BlocConsumer<WellDetailBloc, WellDetailState>(
                                    listener: (context, state) {
                                      // اینجا فقط برای کارهای جانبی مثل نمایش Toast یا Navigate است
                                    },
                                    builder: (context, state) {
                                      if (state.wellWorkStatus is WeekWellWorkSuccess) {
                                        final successState = state.wellWorkStatus as WeekWellWorkSuccess;

                                        // ۱. استخراج داده‌ها (فرض بر این است که ایندکس 0 لیست مورد نظر شماست)
                                        final currentYValues = successState.currentWellWorkEntity.list.yAxis ;
                                        final currentXValues = successState.currentWellWorkEntity.list.xAxis ;
                                        List<dynamic> previousYValues=[];
                                        List<dynamic> previousXLabels=[];
                                        if(successState.previousWellWorkEntity!=null){
                                           previousYValues = successState.previousWellWorkEntity!.list.yAxis! ;
                                           previousXLabels = successState.currentWellWorkEntity.list.xAxis! ;
                                        }

                                        if ((currentYValues==null || currentYValues.isEmpty) ||
                                            (currentXValues==null || currentXValues.isEmpty)
                                        ) {
                                          return  Center(child: Constants.noData());
                                        }
                                        final scale = successState.previousWellWorkEntity==null?Constants().getScale(currentYValues):
                                        Constants().getChartScale(currentYValues,previousYValues);

                                        List<BarChartGroupData> chartGroups = List.generate(
                                            successState.previousWellWorkEntity==null?currentYValues.length:7, (index) {
                                          return BarChartGroupData(
                                            x: index,
                                            barRods: [
                                              BarChartRodData(
                                                // چک کردن لیست اول
                                                toY: index < currentYValues.length ? currentYValues[index].toDouble() : 0.0,
                                                color: Colors.orange,
                                                width: 12,
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                              ),
                                             if(successState.previousWellWorkEntity!=null) BarChartRodData(
                                                // چک کردن لیست دوم
                                                toY: index < previousYValues.length ? previousYValues[index].toDouble() : 0.0,
                                                color: ColorPalette.grey,
                                                width: 12,
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                                              ),
                                            ],
                                          );
                                        });
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Container(

                                              height: 300,
                                              padding: const EdgeInsets.only(top: 40, right: 18.0,bottom: 10),
                                              child: BarChart(
                                                BarChartData(
                                                    extraLinesData: ExtraLinesData(
                                                      horizontalLines: Constants().generateHorizontalLines((scale['step'] as num).toDouble(), scale["maxY"]!,scale["minY"]!),
                                                    ),

                                                    maxY: scale['maxY'],
                                                    minY: scale['minY'],
                                                    alignment: BarChartAlignment.spaceAround,
                                                    gridData:  FlGridData(
                                                      show: false,
                                                      verticalInterval: scale['step'],
                                                      getDrawingHorizontalLine: (value) {
                                                        return FlLine(
                                                            strokeWidth: 1,
                                                            color: Colors.grey
                                                        );
                                                      },
                                                    ),
                                                    barTouchData: BarTouchData(
                                                        handleBuiltInTouches: true,
                                                        touchTooltipData: BarTouchTooltipData(
                                                          getTooltipColor: (group) => ColorPalette.lightGrey,
                                                          fitInsideHorizontally: true, // جلوگیری از بیرون زدن افقی از چپ/راست
                                                          fitInsideVertically: true,   // جلوگیری از بیرون زدن عمودی از بالا/پایین
                                                        )
                                                    ),
                                                    borderData: FlBorderData(
                                                      border:  Border(bottom: BorderSide(color: ColorPalette.lightGrey)),                                                    ),
                                                    titlesData: FlTitlesData(
                                                      show: true,
                                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                      bottomTitles: successState.previousWellWorkEntity==null?
                                                      Constants().axisBottomTitles(currentXValues,"clock"):
                                                      Constants().axisBottomTitles(previousXLabels,"week"),

                                                      leftTitles: Constants().leftTitles(interval:scale["maxY"]! > 1000 ? 65.w : 40.w,
                                                         scale:  scale['step'] == 0 ? 10 : scale['step']!),
                                                    ),
                                                    barGroups: chartGroups
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Indicator(color: ColorPalette.orange, text: 'هفته جاری', isSquare: true),
                                                Indicator(color: Colors.grey, text: 'هفته گذشته', isSquare: true),
                                              ],

                                            ),
                                          ],
                                        );
                                      }
                                      else if (state.wellWorkStatus is WeekWellWorkLoading) {
                                        return state.selectedChartTab == 0
                                            ?  ShimmerClass.lineChartShimmer()
                                            :  ShimmerClass.barChartShimmer() ;
                                      } else if (state.wellWorkStatus is WeekWellWorkError) {
                                        final errorState = state.wellWorkStatus as WeekWellWorkError;
                                        return Center(child: Text(errorState.error));
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),


                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10.h),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("عملکرد پمپ چاه در هفته جاری",style: TextStyleP.f12Regular,),
                                SizedBox(
                                  height: 10,
                                ),
                                BlocBuilder<WellDetailBloc,WellDetailState>(builder: (context, state) {
                                  if(state.wellPerformanceStatus is WellPerformanceSuccess){
                                    WellPerformanceSuccess wellWorkSuccess=state.wellPerformanceStatus as WellPerformanceSuccess;
                                    final flowMeter=wellWorkSuccess.wellFlowMeterEntity;
                                    final currentWork=wellWorkSuccess.currentWellWorkEntity;
                                    // ۱. استخراج دو لیست جهت دسترسی آسان‌تر
                                    final flowMeterX = wellWorkSuccess.wellFlowMeterEntity.list.xAxis ?? [];
                                    final flowMeterY = wellWorkSuccess.wellFlowMeterEntity.list.yAxis ?? [];

                                    final currentWorkX = wellWorkSuccess.currentWellWorkEntity.list.xAxis ?? [];
                                    final currentWorkY = wellWorkSuccess.currentWellWorkEntity.list.yAxis ?? [];
                                      // ۳. ایجاد Map از هشدارها بر اساس period برای دسترسی سریع (در صورت غیرنالی بودن alertList)
                                    final Map<String, String> alertMap = {
                                      for (var alert in wellWorkSuccess.alertCountEntity.alertCountByDate ?? [])
                                        if (alert.period != null && alert.count != null) alert.period!: alert.count!
                                    };
                                          // ۲. انتخاب لیستی که xAxis بزرگ‌تری دارد به عنوان پایه
                                    final bool isFlowMeterBigger = flowMeterX.length >= currentWorkX.length;
                                    final baseListX = isFlowMeterBigger ? flowMeterX : currentWorkX;
                                    return flowMeter.list.xAxis!.isEmpty && currentWork.list.xAxis!.isEmpty
                                  ?
                                    Constants.noData():
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        width: 500,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: ColorPalette.grey),
                                            borderRadius: BorderRadius.circular(3)

                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: baseListX.length + 1,
                                          itemBuilder: (context, index) {

                                            if (index == 0) {
                                              return Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xffD7D7D7),
                                                  border: Border(bottom: BorderSide(color: ColorPalette.grey)),
                                                ),
                                                child: const Row(
                                                  children: [
                                                    Expanded(child: Text("تاریخ", textAlign: TextAlign.center)),
                                                    Expanded(child: Text("ساعات کارکرد پمپ", textAlign: TextAlign.center)),
                                                    Expanded(child: Text("حجم مصرفی", textAlign: TextAlign.center)),
                                                    Expanded(child: Text("تعداد هشدار", textAlign: TextAlign.center)),
                                                  ],
                                                ),
                                              );
                                            }

                                            // ایندکس واقعی داده‌ها (با توجه به سطر هدر)
                                            final dataIndex = index - 1;
                                            final currentDate = baseListX[dataIndex];

                                            // مقایسه و پیدا کردن مقدار hours در لیست currentWellWork
                                            final workIndex = currentWorkX.indexOf(currentDate);
                                            final String workHours = (workIndex != -1 && workIndex < currentWorkY.length)
                                                ? currentWorkY[workIndex].toString().toPersianDigit()
                                                : "۰";

                                            // مقایسه و پیدا کردن مقدار volume در لیست wellFlowMeter
                                            final flowIndex = flowMeterX.indexOf(currentDate);
                                            final String flowVolume = (flowIndex != -1 && flowIndex < flowMeterY.length)
                                                ? flowMeterY[flowIndex].toString().toPersianDigit()
                                                : "۰";

                                            // بررسی وجود تاریخ در مپ هشدارها
                                            final String alertCount = (currentDate != null && alertMap.containsKey(currentDate))
                                                ? alertMap[currentDate]!.toString().toPersianDigit()
                                                : "-";

                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                              decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: ColorPalette.grey, width: 1)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(currentDate.toString().toPersianDigit(),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(workHours,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Directionality(
                                                      textDirection: TextDirection.ltr,
                                                      child: Text(flowVolume,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(alertCount,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }else if(state.wellPerformanceStatus is WellPerformanceLoading){
                                    return ShimmerClass.shimmerListviewVertical(height: 50);
                                  }else if(state.wellPerformanceStatus is WellPerformanceError){
                                    WellPerformanceError wellWorkError=state.wellPerformanceStatus as WellPerformanceError;
                                    return Center(child: Text(wellWorkError.error));
                                  }else{
                                    return SizedBox();
                                  }
                                },),
                                SizedBox(
                                  height: 250.h,
                                  child: BlocBuilder<WellDetailBloc, WellDetailState>(
                                    buildWhen: (previous, current) {

                                      if (builtOnce) return false;

                                      if (current.wellWorkStatus is WeekWellWorkSuccess) {
                                        builtOnce = true;
                                      }

                                      return true;
                                    },
                                    builder: (context, state) {
                                      if (state.wellWorkStatus is WeekWellWorkLoading) {
                                        return ShimmerClass.pieChartShimmer();
                                      } else if (state.wellWorkStatus is WeekWellWorkSuccess) {
                                        WeekWellWorkSuccess wellWorkSuccess = state.wellWorkStatus as WeekWellWorkSuccess;
                                        final dynamic on = wellWorkSuccess.currentWellWorkEntity.list.totalOn;
                                        final dynamic off = wellWorkSuccess.currentWellWorkEntity.list.totalOff;

                                        return Center(
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                PieChart(
                                                  PieChartData(
                                                    sectionsSpace: 0,
                                                    centerSpaceRadius: 80,
                                                    sections: showingSections(
                                                      on: on,
                                                      off: off,
                                                    ),
                                                  ),
                                                  duration: const Duration(milliseconds: 150),
                                                  curve: Curves.linear,
                                                ),

                                                Column(
                                                  mainAxisSize: MainAxisSize.min, // باعث می‌شود ستون فقط به اندازه محتوایش فضا بگیرد
                                                  children: [
                                                    Text(
                                                      textAlign: TextAlign.center,
                                                      "${wellWorkSuccess.currentWellWorkEntity.list.totalOn.toString().toPersianDigit()} ساعت\nاز ${(on+off).toStringAsFixed(2).toString().toPersianDigit()} ساعت",
                                                      style: TextStyleP.f14Bold,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      "ساعات کارکرد پمپ",
                                                      style: TextStyleP.f12Regular,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ));
                                      } else if (state.wellWorkStatus is WeekWellWorkError) {
                                        WeekWellWorkError wellWorkError = state
                                            .wellWorkStatus as WeekWellWorkError;
                                        return Center(child: Text(wellWorkError.error));
                                      } else {
                                        return SizedBox();
                                      }
                                    },),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Indicator(color: ColorPalette.darkBlue, text: 'مجموع ساعات روشن بودن', isSquare: false),
                                    Indicator(color: Colors.grey.shade400, text: 'مجموع ساعات خاموش بودن', isSquare: false),
                                  ],
                                ),

                              ],
                            )),
                        SizedBox(height: 10),

                      ],
                    ):
                    BlocBuilder<WellDetailBloc, WellDetailState>(
                    builder: (context, state) {
                      return Container(
                      child: state.userLocalId == null
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "کنترل ${widget.wellsDataEntity.wellName}",
                                style: TextStyleP.f16Medium,
                              ),
                              SizedBox(height: 55.h),
                              Container(
                              padding: EdgeInsets.all(16.sp),

                              decoration: BoxDecoration(
                                color: Colors.white,
                              // color: wellsDataEntity.userLocalId==null?Colors.redAccent:Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  color: ColorPalette.lightGrey.withValues(alpha:5)

                                )
                              ],
                              borderRadius: BorderRadius.circular(5),
                              ),

                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Row(
                                  children: [
                                    IconContainer(icon: Image.asset("assets/icons/finger-scan.png",scale: 0.7,),
                                      color: ColorPalette.tGrey,
                                   ),
                                    SizedBox(width: 10),

                                    Text("اثر انگشت",style: TextStyleP.f14Medium),
                                  ],
                                ),
                                SizedBox(height: 51.h),
                                BlocConsumer<WellDetailBloc, WellDetailState>(
                                  listenWhen: (previous, current) => previous.fingerStatus != current.fingerStatus,
                                  listener: (context, state) {
                                    final status = state.fingerStatus;

                                    if (status is FingerLoading || status is FingerRequestAccepted) {
                                      if (!_controller.isAnimating) {
                                        _controller.reset();
                                        _controller.forward();
                                      }
                                    } else if (status is FingerSuccess || status is FingerError || status is FingerRequestFailed) {
                                      _controller.stop();
                                    }

                                    if (status is FingerError) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(status.error.isNotEmpty ? status.error : "پاسخی از سمت دستگاه دریافت نشد."),
                                          backgroundColor: Colors.red,
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    final fingerStatus = state.fingerStatus;
                                    print("fingerStatus$fingerStatus");

                                    // بررسی اینکه آیا فرآیند در حال اجراست یا خیر
                                    // final bool isLoading = fingerStatus is FingerLoading ||
                                    //     fingerStatus is FingerRequestAccepted;

                                    // ۱. حالت موفقیت‌آمیز
                                    if (fingerStatus is FingerSuccess) {
                                      return fingerStatus.status == 1 || fingerStatus.status == "1"
                                          ? const Text("اثر انگشت با موفقیت ثبت شد.")
                                          : _buildActionButton(
                                        message: "عدم پاسخ مناسب از دستگاه، مجدد تلاش کنید.",
                                        isDisabled: false,
                                      );
                                    }

                                    // ۲. حالت درخواست پذیرفته شد (دستگاه منتظر لمس انگشت است)
                                    else if (fingerStatus is FingerRequestAccepted) {
                                      return Column(
                                        children: [
                                          const Text("دستگاه آماده است. لطفا اثر انگشت خود را روی سنسور بگذارید."),
                                          const SizedBox(height: 15),
                                          _buildProgressBar(),
                                          const SizedBox(height: 15),
                                          _buildActionButton(
                                            message: "",
                                            isDisabled: true, // دکمه غیرفعال در زمان تایمر
                                          ),
                                        ],
                                      );
                                    }

                                    // ۳. حالت لودینگ و برقراری ارتباط اولیه
                                    else if (fingerStatus is FingerLoading) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildProgressBar(),
                                          const SizedBox(height: 15),
                                          _buildActionButton(
                                            message: "در حال درخواست به دستگاه، لطفاً کمی منتظر بمانید...",
                                            isDisabled: true, // دکمه غیرفعال در زمان تایمر
                                          ),
                                        ],
                                      );
                                    }

                                    // ۴. حالت خطا یا پایان تایمر
                                    else if (fingerStatus is FingerError) {
                                      return _buildActionButton(
                                        message: "خطایی رخ داده یا زمان به پایان رسیده است.",
                                        isDisabled: false, // فعال شدن مجدد دکمه
                                      );
                                    }

                                    // ۵. حالت اولیه (شروع)
                                    else{
                                      return _buildActionButton(
                                        message: "برای کنترل دستگاه ابتدا باید اثر انگشت خود را ثبت نمایید.",
                                        isDisabled: false,
                                      );
                                    }
                                  },
                                )
                              ],
                                                      ),
                                                    ),
                            ],
                          )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "کنترل ${widget.wellsDataEntity.wellName}",
                            style: TextStyleP.f16Medium,
                          ),
                          SizedBox(height: 8.h),

                          Text(
                            "با استفاده از کنترل‌های زیر می‌توانید به دستگاه دستور دهید.",
                            style: TextStyleP.f12Regular,
                          ),

                          SizedBox(height: 32.h),

                          ///switch
                          Container(
                            height: 70.h,
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: ColorPalette.white,
                              borderRadius: BorderRadius.circular(8),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Row(
                                  children: [
                                    IconContainer(
                                      icon: Image.asset("assets/icons/pomp.png"),
                                      color: ColorPalette.iconContainerColor,
                                      width: 24,
                                      height: 24,
                                    ),
                                    SizedBox(width: 9),

                                    Text("کنترل لحظه‌ای پمپ"),
                                  ],
                                ),
                                BlocListener<WellDetailBloc, WellDetailState>(
                                  listenWhen: (previous, current) => previous.isSwitched!=current.isSwitched,
                                  listener: (context, state) {
                                    if (state.onOffStatus is OnOffSuccess) {
                                      // ۱. ابتدا دیالوگ باز شده را می‌بندیم (چون روی صفحه اصلی باز شده بود با کانتکست اصلی pop می‌شود)
                                      // Navigator.of(context).pop();

                                      // ۲. نمایش موفقیت
                                      GlobalSnackBar.show(context,
                                        message: state.isSwitched == true ? "با موفقیت روشن شد" : "با موفقیت خاموش شد",
                                      );
                                    }

                                    if (state.onOffStatus is OnOffError) {
                                      GlobalSnackBar.show(context, message: "خطایی رخ داده است");
                                    }
                                  },

                                  child: CupertinoSwitch(
                                    activeTrackColor: ColorPalette.lightBlue,
                                    thumbColor: ColorPalette.darkBlue,
                                    inactiveThumbColor: ColorPalette.black.withValues(alpha: 0.5),
                                    value: state.isSwitched!,
                                    onChanged: (value) {

                                      // print(value);
                                      ShowDialogs().turnPomp(context,
                                        BlocProvider.of<WellDetailBloc>(context),
                                        value,widget.wellsDataEntity,);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 32),

                          ///program
                          Program(wellsDataEntity: widget.wellsDataEntity,),

                        ],
                      )
                    );
                },
                  );
                  },)

                ],
              ),
            ),
          )
      ),
    );
  }

  // ویجت دکمه با قابلیت غیرفعال شدن (Disabled)
  Widget _buildActionButton({
    required String message,
    required bool isDisabled,
  }) {
    return Column(
      children: [
        if (message.isNotEmpty) ...[
          Text(message,style: TextStyleP.f12Regular),
          const SizedBox(height: 20),
        ],
        GlobalElevatedButton(
          widget:  Text("ثبت اثر انگشت",style: TextStyle(color: ColorPalette.black),),
          backColor: ColorPalette.darkBlue,
          // با پاس دادن null به onTap، دکمه غیرفعال می‌شود
          onTap: isDisabled ? null : _startProcess,
        ),
      ],
    );
  }

  // ویجت نوار پیشرفت تایمر
  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: double.infinity,
          height: 15,
          child: LinearProgressIndicator(
            value: _controller.value,
            borderRadius: BorderRadius.circular(15),
            backgroundColor: const Color(0xffD3D9E0),
            color: ColorPalette.darkBlue,
          ),
        );
      },
    );
  }

}
