import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/socket_repository.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_data_entity.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/flowmeter_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/pump_performance_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/well_detail_bloc.dart';
import 'package:mahaliii/features/well_feature/presentation/screens/widgets/program_widget.dart';
import 'package:mahaliii/features/well_feature/presentation/screens/widgets/signal_widget.dart';
import 'package:mahaliii/features/well_feature/presentation/screens/widgets/switch_pump.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/icon_container.dart';
import '../../../../common/widgets/indicator_widget.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../../../../locator.dart';
import '../../../auth_feature/presentation/screens/login_screen.dart';
import '../bloc/well_detail_bloc/finger_status.dart';
import '../bloc/well_detail_bloc/week_well_work_status.dart';

class WellDetailScreen extends StatefulWidget {
  const WellDetailScreen({super.key, required this.wellsDataEntity});

  final WellsDataEntity wellsDataEntity;

  @override
  State<WellDetailScreen> createState() => _WellDetailScreenState();
}

class _WellDetailScreenState extends State<WellDetailScreen>
    with SingleTickerProviderStateMixin {
  List<String> liveXLabels = [];
  List<dynamic> liveYValues = [];
  int currentTab = -1; // برای هندل کردن تغییر تب‌ها
  // late AnimationController _controller;
  List<PieChartSectionData> showingSections({dynamic on, dynamic off}) {
    final double onValue = (on is num) ? on.toDouble() : 0.0;
    final double offValue = (off is num) ? off.toDouble() : 0.0;
    final double remainingValue = (168 - (onValue + offValue)).clamp(0.0, 168.0);

    // final shadows = [ Shadow(color: ColorPalette.black, blurRadius: 2)];

    return List.generate(3, (i) {
      final double radius =  38.0.r;

      return switch (i) {
        0 => PieChartSectionData(
          color: ColorPalette.darkGreen,
          value: onValue,
          title: onValue > 0 ? '${onValue.toStringAsFixed(2).toPersianDigit()}' : '',

          radius: radius,
          titleStyle: TextStyle(
            fontSize:  13.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,

          ),
        ),
        1 => PieChartSectionData(
          color: ColorPalette.darkRed,
          value: offValue,
          title: offValue > 0 ? '${offValue.toStringAsFixed(2).toPersianDigit()}' : '',

          radius: radius,
          titleStyle: TextStyle(
            fontSize:  13.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,

          ),
        ),
        2 => PieChartSectionData(
          color: ColorPalette.lightGrey,
          value: remainingValue,
          title: remainingValue > 0
              ? remainingValue.toStringAsFixed(2).toPersianDigit()
              : '',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,

          ),
        ),
        _ => throw UnimplementedError(),
      };
    });
  }

  bool builtOnce = false;
  bool selected=false;

  late WellDetailBloc _bloc;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    // ۱. دریافت نمونه تازه از BLoC
    _bloc = locator<WellDetailBloc>();

    final wellPin = widget.wellsDataEntity.pin ?? "";
    locator<SocketRepository>().joinWellRoom(wellPin);

    // ۲. ارسال ایونت‌ها به نمونه فعال
    _bloc
      ..add(WellWorkHourStart(FlowMeterParams(type: 2, ids: [widget.wellsDataEntity.deviceId!])))
      ..add(WellPerformance(FlowMeterParams(type: 2, time: 2, ids: [widget.wellsDataEntity.deviceId!])))
      ..add(FlowMeterEvent(FlowMeterParams(type: 0, ids: [widget.wellsDataEntity.deviceId!])))
      ..add(GetProgram(widget.wellsDataEntity.id!))
      ..add(FirstSwitch(widget.wellsDataEntity.statusWell == 1))
      ..add(ChangeUserLocalId(widget.wellsDataEntity.userLocalId))
      ..add(AutoSwitchChange(widget.wellsDataEntity.deviceId!))
      ..add(SignalQuality(widget.wellsDataEntity.signalLevel!,widget.wellsDataEntity.deviceId!));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 90),
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
    _bloc.close(); // ۳. بستن BLoC هنگام خروج از صفحه
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
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {

    return BlocProvider.value(
      value: _bloc,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          // برگرداندن وضعیت فعلی سوئیچ هنگام خروج
          Navigator.of(context).pop({
            'isSwitched': _bloc.state.isSwitched,
            'userLocalId': _bloc.state.userLocalId, //  برگرداندن userLocalId واقعی که ثبت شده است

          });
          // Navigator.of(context).pop( _bloc.state.userLocalId);

        },
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Container(
                color: ColorPalette.white,
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 8.h),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<WellDetailBloc, WellDetailState>(
                        builder: (context, state) {
                          return SegmentedButton(
                            style: SegmentedButton.styleFrom(
                              backgroundColor: ColorPalette.lightGrey,
                            ),
                            onSelectionChanged: (Set<int> newSelected) {
                              BlocProvider.of<WellDetailBloc>(context)
                                  .add(ChangeWellTab(newSelected.first));
                            },
                            segments: const [
                              ButtonSegment(value: 0, label: Text("وضعیت کلی")),
                              ButtonSegment(value: 1, label: Text("کنترل چاه")),
                            ],
                            selected: {state.selectedWellTab},
                          );
                        },
                      ),

                      Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: BoxBorder.all(),
                        ),

                        child: IconButton(

                          padding: EdgeInsets.zero,

                          icon: const Icon(Icons.navigate_next),
                          onPressed: () {
                            Navigator.of(context).pop({
                              'isSwitched': _bloc.state.isSwitched,
                              'userLocalId': _bloc.state.userLocalId, //  برگرداندن userLocalId واقعی که ثبت شده است

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 16.w,right: 16.w,),
                    child: BlocSelector<WellDetailBloc, WellDetailState, int>(
                      selector: (state) => state.selectedWellTab,


                      builder: (context, selectedTab) {
                        return selectedTab==0?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding:  EdgeInsets.only(top:20.h),
                              child: Text(
                                "خلاصه وضعیت ${widget.wellsDataEntity.wellName}",
                                style: TextStyleP.f16Medium,
                              ),
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
                                            Text("حجم مصرف آب", style: TextStyleP.f12Regular),
                                            BlocBuilder<WellDetailBloc, WellDetailState>(
                                              buildWhen: (previous, current) =>
                                              current.selectedChartVolumeTab!=previous.selectedChartVolumeTab ||
                                                  current.flowMeterStatus!=previous.flowMeterStatus,
                                              builder: (context, state) {
                                                return Row(
                                                  children: [
                                                    GlobalElevatedButton(
                                                      backColor: state.selectedChartVolumeTab==0?ColorPalette.inverseBlue:ColorPalette.lightGrey,
                                                      borderRadius: 50,

                                                      widget: Text("امروز",style: TextStyle(color: ColorPalette.black),),
                                                      onTap:state.flowMeterStatus is FlowMeterLoading?null: () {
                                                        BlocProvider.of<WellDetailBloc>(context).add(
                                                          FlowMeterEvent(
                                                            FlowMeterParams(
                                                              type: 0,
                                                              ids: [widget.wellsDataEntity.deviceId!],
                                                            ),
                                                          ),
                                                        );
                                                      },),

                                                    SizedBox(width: 10.w),
                                                    GlobalElevatedButton(
                                                        borderRadius: 50,
                                                        backColor: state.selectedChartVolumeTab==6?ColorPalette.inverseBlue:ColorPalette.lightGrey,
                                                        widget: Text("هفته",style: TextStyle(color: ColorPalette.black),),
                                                        onTap:state.flowMeterStatus is FlowMeterLoading?null: () {
                                                          BlocProvider.of<WellDetailBloc>(context).add(
                                                            FlowMeterEvent(
                                                              FlowMeterParams(
                                                                type: 6,
                                                                ids: [widget.wellsDataEntity.deviceId!],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        BlocConsumer<WellDetailBloc, WellDetailState>(
                                          buildWhen: (previous, current) {
                                            return previous.flowMeterStatus != current.flowMeterStatus ||
                                                previous.selectedChartVolumeTab != current.selectedChartVolumeTab;
                                          },
                                          listener: (context, state) {
                                            if (state.flowMeterStatus is FlowMeterExit) {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
                                            }

                                            // تشخیص تغییر تب برای ریسِت کردن کشِ نمودار
                                            if (currentTab != state.selectedChartVolumeTab) {
                                              currentTab = state.selectedChartVolumeTab;
                                              liveXLabels.clear();
                                              liveYValues.clear();
                                            }

                                            // ۱. مقداردهی اولیه لیست‌ها از API (فقط وقتی لیست کش خالی است)
                                            if (state.flowMeterStatus is FlowMeterSuccess && liveXLabels.isEmpty) {
                                              final flowMeter = (state.flowMeterStatus as FlowMeterSuccess).wellFlowMeterEntity?.list;
                                              if (flowMeter != null) {
                                                liveXLabels = List<String>.from(flowMeter.xAxis ?? []);
                                                liveYValues = (flowMeter.yAxis ?? []).map((e) => (e ?? 0).toDouble()).toList();
                                              }
                                            }

                                          },
                                          builder: (context, state) {
                                            final status = state.flowMeterStatus;

                                            if (status is FlowMeterLoading) {
                                              return state.selectedChartVolumeTab == 0
                                                  ? ShimmerClass.lineChartShimmer()
                                                  : ShimmerClass.barChartShimmer();
                                            }

                                            if (status is FlowMeterError) {
                                              return const Text("خطایی رخ داده");
                                            }

                                            if (status is! FlowMeterSuccess) {
                                              if (status is FlowMeterEmpty) return Constants.noData();
                                              return const SizedBox.shrink();
                                            }

                                            // بررسی اینکه لیست کش ما خالی نباشد
                                            if (liveXLabels.isEmpty || liveYValues.isEmpty) {
                                              return Constants.noData();
                                            }

                                            // ۳. استفاده از مقادیر لایو و آپدیت‌شده برای محاسبات نمودار
                                            final scale = Constants().getScale(liveYValues);

                                            final List<FlSpot> spots = List.generate(
                                              liveYValues.length,
                                                  (j) => FlSpot(j.toDouble(), liveYValues[j]),
                                            );

                                            final List<BarChartGroupData> chartGroups = List.generate(liveYValues.length, (index) {
                                              return BarChartGroupData(
                                                x: index,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: liveYValues[index],
                                                    color: ColorPalette.chartBlue,
                                                    width: 15.w,
                                                    borderRadius: BorderRadius.circular(2),
                                                  ),
                                                ],
                                              );
                                            });

                                            final double columnWidth = 80.0;
                                            final double calculatedChartWidth = (liveXLabels.length * columnWidth).clamp(350.0, 2000.0);

                                            return Column(
                                              children: [
                                                Directionality(
                                                  textDirection: TextDirection.ltr,
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Container(
                                                        width: calculatedChartWidth,
                                                        height: 250.h,
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
                                                              border: Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                                                            ),
                                                            titlesData: FlTitlesData(
                                                              bottomTitles: Constants().axisBottomTitles(liveXLabels, "day"),
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
                                                                maxContentWidth: 250.w,
                                                                tooltipBorder: BorderSide(color: ColorPalette.lightGrey),
                                                                getTooltipColor: (LineBarSpot touchedSpot) => ColorPalette.white,
                                                                fitInsideHorizontally: true,
                                                                fitInsideVertically: true,
                                                                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                                                                  if (touchedSpots.isEmpty) return [];
                                                                  final spot = touchedSpots.first;
                                                                  final int xIndex = spot.x.toInt();
                                                                  if (xIndex < 0 || xIndex >= liveXLabels.length) return [];

                                                                  final String values = liveYValues[xIndex].toStringAsFixed(2).toString().toPersianDigit();
                                                                  List<TextSpan> spans = [
                                                                    TextSpan(
                                                                      text: "حجم آب عبوری دبی سنج: ${values}\n",
                                                                      style: const TextStyle(
                                                                        color: Colors.black87,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 12,
                                                                      ),
                                                                    ),
                                                                  ];

                                                                  return touchedSpots.map((s) {
                                                                    if (s == spot) {
                                                                      return LineTooltipItem(
                                                                        textAlign: TextAlign.right,
                                                                        "",
                                                                        const TextStyle(),
                                                                        children: spans,
                                                                      );
                                                                    }
                                                                    return null;
                                                                  }).toList();
                                                                },
                                                              ),
                                                              handleBuiltInTouches: true,
                                                            ),
                                                            lineBarsData: [
                                                              LineChartBarData(
                                                                preventCurveOverShooting: true,
                                                                preventCurveOvershootingThreshold: 0,
                                                                dotData: const FlDotData(show: false),
                                                                isCurved: true,
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
                                                                maxContentWidth: 250.w,
                                                                tooltipBorder: BorderSide(color: ColorPalette.lightGrey),
                                                                getTooltipColor: (group) => ColorPalette.white, // پس‌زمینه ملایم
                                                                fitInsideHorizontally: true,
                                                                fitInsideVertically: true,
                                                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                                  final int xIndex = group.x.toInt();
                                                                  if (xIndex < 0 || xIndex >= liveXLabels.length) return null;

                                                                  final double currentDate = liveYValues[xIndex];

                                                                  List<TextSpan> spans = [];

                                                                  // ۲. استخراج ساعت یا تاریخ اصلی (جدا کردن ساعت اگر شامل فاصله باشد)
                                                                  final String timeLabel = currentDate.toStringAsFixed(2).toString().toPersianDigit();

                                                                  spans.add(
                                                                    TextSpan(
                                                                      text: "حجم آب عبوری دبی سنج: $timeLabel",
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

                                                            borderData: FlBorderData(
                                                              border:  Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                                                            ),
                                                            titlesData: FlTitlesData(
                                                              show: true,
                                                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                              bottomTitles: Constants().axisBottomTitles(liveXLabels, "week"),
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
                                                SizedBox(height: 16.h),
                                              ],
                                            );
                                          },
                                        )
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
                                            current.selectedChartTab!=previous.selectedChartTab ||
                                                current.weekWellWorkStatus!=previous.weekWellWorkStatus,
                                            builder: (context, state) {
                                              return Row(
                                                children: [
                                                  GlobalElevatedButton(
                                                    backColor: state.selectedChartTab==0?ColorPalette.inverseBlue:ColorPalette.lightGrey,
                                                    borderRadius: 50,

                                                    widget: Text("امروز",style: TextStyle(color: ColorPalette.black),),
                                                    onTap:state.weekWellWorkStatus is WeekWellWorkLoading?null: () {
                                                      BlocProvider.of<WellDetailBloc>(context).add(
                                                        WellWorkHourStart(
                                                          FlowMeterParams(
                                                            type: 0,
                                                            ids: [widget.wellsDataEntity.deviceId!],
                                                          ),
                                                        ),
                                                      );
                                                    },),

                                                  SizedBox(width: 10.w),
                                                  GlobalElevatedButton(
                                                      borderRadius: 50,
                                                      backColor: state.selectedChartTab==2?ColorPalette.inverseBlue:ColorPalette.lightGrey,
                                                      widget: Text("هفته",style: TextStyle(color: ColorPalette.black),),
                                                      onTap:state.weekWellWorkStatus is WeekWellWorkLoading?null: () {
                                                        BlocProvider.of<WellDetailBloc>(context).add(
                                                          WellWorkHourStart(
                                                            FlowMeterParams(
                                                              type: 2,
                                                              ids: [widget.wellsDataEntity.deviceId!],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      BlocConsumer<WellDetailBloc, WellDetailState>(
                                        listener: (context, state) {
                                          // اینجا فقط برای کارهای جانبی مثل نمایش Toast یا Navigate است
                                        },
                                        builder: (context, state) {
                                          if (state.weekWellWorkStatus is WeekWellWorkSuccess) {
                                            final successState = state.weekWellWorkStatus as WeekWellWorkSuccess;

                                            // ۱. استخراج داده‌ها (فرض بر این است که ایندکس 0 لیست مورد نظر شماست)
                                            final currentYValues = successState.currentWellWorkEntity.list.yAxis ;
                                            final currentXValues = successState.currentWellWorkEntity.list.xAxis ;
                                            List<dynamic> previousYValues=[];
                                            List<dynamic> previousXLabels=[];
                                            if(successState.previousWellWorkEntity!=null){
                                              previousYValues = successState.previousWellWorkEntity!.list.yAxis! ;
                                              previousXLabels = successState.previousWellWorkEntity!.list.xAxis! ;
                                            }

                                            if ((currentYValues==null || currentYValues.isEmpty) ||
                                                (currentXValues==null || currentXValues.isEmpty)
                                            ) {
                                              return  Constants.noData();
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
                                                    color: ColorPalette.chartBlue,
                                                    width: 15.w,
                                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                                  ),
                                                  if(successState.previousWellWorkEntity!=null) BarChartRodData(
                                                    // چک کردن لیست دوم
                                                    toY: index < previousYValues.length ? previousYValues[index].toDouble() : 0.0,
                                                    color: ColorPalette.lightGrey,
                                                    width: 15.w,
                                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
                                                  ),
                                                ],
                                              );
                                            });
                                            double chartWidth = currentXValues.length * 40.0;
                                            double screenWidth = MediaQuery.of(context).size.width;
                                            if (chartWidth < screenWidth) {
                                              chartWidth = screenWidth; // اگر دیتا کم بود، چارت کل صفحه را پر کند
                                            }

                                            return Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  width: chartWidth,
                                                  height: 300.h,
                                                  padding:  EdgeInsets.only(top: 40.h, right: 18.0.w, bottom: 10.h),
                                                  child: state.selectedChartTab == 0
                                                      ? SizedBox(
                                                    height: 250.h,
                                                    child: AspectRatio(
                                                      aspectRatio: 2,
                                                      child: Padding(
                                                        padding:  EdgeInsets.only(right: 20.0.w, left: 12.w),
                                                        child: LineChart(
                                                          LineChartData(
                                                            lineBarsData: [
                                                              LineChartBarData(
                                                                isStepLineChart: true,
                                                                spots: currentYValues.asMap().entries.map((e) {
                                                                  return FlSpot(e.key.toDouble(), (e.value as int).toDouble());
                                                                }).toList(),
                                                                isCurved: false,
                                                                dotData: const FlDotData(show: false),
                                                                color: ColorPalette.darkGreen,
                                                              ),
                                                            ],
                                                            minY: 0,
                                                            gridData: FlGridData(
                                                              show: false,
                                                              verticalInterval: scale['step'],
                                                              getDrawingHorizontalLine: (value) {
                                                                return FlLine(
                                                                  strokeWidth: 1,
                                                                  color: Colors.grey,
                                                                );
                                                              },
                                                            ),
                                                            lineTouchData: LineTouchData(
                                                              handleBuiltInTouches: false,

                                                            ),

                                                            borderData: FlBorderData(
                                                              border: Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                                                            ),
                                                            titlesData: FlTitlesData(
                                                              show: true,
                                                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                              bottomTitles: Constants().axisBottomTitles(currentXValues, "clock"),
                                                              leftTitles: AxisTitles(
                                                                sideTitles: SideTitles(
                                                                  showTitles: true,
                                                                  interval: 1, // فاصله ۱ برای نمایش دقیق ۰ و ۱
                                                                  reservedSize: 55.w, // فضای کافی برای کلمات
                                                                  getTitlesWidget: (value, meta) {
                                                                    String text = "";
                                                                    if (value == 0) {
                                                                      text = "خاموش";
                                                                    } else if (value == 1) {
                                                                      text = "روشن";
                                                                    } else {
                                                                      return const SizedBox.shrink();
                                                                    }

                                                                    return Padding(
                                                                      padding: const EdgeInsets.only(left: 4),
                                                                      child: Text(
                                                                        text,
                                                                        style: const TextStyle(
                                                                          fontSize: 10,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                      : SizedBox(
                                                    height: 250.h,
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: AspectRatio(
                                                            aspectRatio: 2,
                                                            child: BarChart(
                                                              BarChartData(
                                                                extraLinesData: ExtraLinesData(
                                                                  horizontalLines: Constants().generateHorizontalLines(
                                                                    (scale['step'] as num).toDouble(),
                                                                    scale["maxY"]!,
                                                                    scale["minY"]!,
                                                                  ),
                                                                ),
                                                                maxY: scale['maxY'],
                                                                minY: scale['minY'],
                                                                alignment: BarChartAlignment.spaceAround,
                                                                gridData: FlGridData(
                                                                  show: false,
                                                                  verticalInterval: scale['step'],
                                                                  getDrawingHorizontalLine: (value) {
                                                                    return FlLine(
                                                                      strokeWidth: 1,
                                                                      color: Colors.grey,
                                                                    );
                                                                  },
                                                                ),
                                                                barTouchData: BarTouchData(
                                                                  handleBuiltInTouches: true,
                                                                  touchTooltipData: BarTouchTooltipData(
                                                                    maxContentWidth: 250.w,
                                                                    tooltipBorder: BorderSide(color: ColorPalette.lightGrey),
                                                                    getTooltipColor: (group) => ColorPalette.white,
                                                                    fitInsideHorizontally: true,
                                                                    fitInsideVertically: true,
                                                                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                                                      final int xIndex = group.x.toInt();

                                                                      List<TextSpan> spans = [];

                                                                      // گرفتن نام روز هفته با ایمنی بالا
                                                                      final String weekDayName = (xIndex < Constants().weekDayNames.length)
                                                                          ? Constants().weekDayNames[xIndex].name
                                                                          : "";

                                                                      // ۱. نمایش روز هفته در خط اول
                                                                      spans.add(
                                                                        TextSpan(
                                                                          text: "$weekDayName\n",
                                                                          style: const TextStyle(
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ),
                                                                      );

                                                                      // خط جداکننده
                                                                      spans.add(
                                                                        const TextSpan(
                                                                          text: "_________________\n",
                                                                          style: TextStyle(
                                                                            color: Colors.black54,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 10,
                                                                          ),
                                                                        ),
                                                                      );

                                                                      // استخراج مقدار هفته جاری (اگر ایندکس معتبر باشد مقدار را بگیر، وگرنه صفر در نظر بگیر)
                                                                      final bool hasCurrentIndex = xIndex < currentYValues.length && currentYValues[xIndex] != null;
                                                                      final double currentV = hasCurrentIndex ? currentYValues[xIndex].toDouble() : 0.0;
                                                                      final String currentLabel = currentV == 0.0 ? "__" : currentV.toStringAsFixed(1).toString().toPersianDigit();

                                                                      // ۲. نمایش هفته جاری (حتی اگر صفر باشد)
                                                                      spans.add(
                                                                        TextSpan(
                                                                          text: "\u2066$currentLabel\u2069 :هفته جاری ",
                                                                          style: const TextStyle(
                                                                            color: Colors.black87,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 12,
                                                                          ),
                                                                        ),
                                                                      );
                                                                      spans.add(
                                                                        TextSpan(
                                                                          text: "●",
                                                                          style: TextStyle(
                                                                            color: ColorPalette.chartBlue,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ),
                                                                      );

                                                                      // ۳. بررسی و نمایش هفته گذشته (فقط اگر وجود داشته باشد)
                                                                      final bool hasPrevious = successState.previousWellWorkEntity != null &&
                                                                          previousYValues.isNotEmpty &&
                                                                          xIndex < previousYValues.length &&
                                                                          previousYValues[xIndex] != null;

                                                                      if (hasPrevious) {
                                                                        spans.add(
                                                                          const TextSpan(
                                                                            text: "\n",
                                                                            style: TextStyle(fontSize: 4),
                                                                          ),
                                                                        );

                                                                        final double previousV = previousYValues[xIndex].toDouble();
                                                                        final String previousLabel = previousV.toStringAsFixed(1).toString().toPersianDigit();

                                                                        spans.add(
                                                                          TextSpan(
                                                                            text: "\u2066$previousLabel\u2069 :هفته گذشته ",
                                                                            style: const TextStyle(
                                                                              color: Colors.black87,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        );
                                                                        spans.add(
                                                                           TextSpan(
                                                                            text: "●",
                                                                            style: TextStyle(
                                                                              color: ColorPalette.lightGrey,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 11,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }

                                                                      return BarTooltipItem(
                                                                        '',
                                                                        const TextStyle(),
                                                                        textAlign: TextAlign.right,
                                                                        children: spans,
                                                                      );
                                                                    },

                                                                  ),
                                                                ),
                                                                borderData: FlBorderData(
                                                                  border: Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                                                                ),
                                                                titlesData: FlTitlesData(
                                                                  show: true,
                                                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                                  bottomTitles:

                                                                  Constants().axisBottomTitles(previousXLabels, "week"),
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
                                                        const SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          children:  [
                                                            Indicator(color: ColorPalette.chartBlue, text: 'هفته جاری', isSquare: true),
                                                            Indicator(color: ColorPalette.lightGrey, text: 'هفته گذشته', isSquare: true),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          else if (state.weekWellWorkStatus is WeekWellWorkLoading) {
                                            return state.selectedChartTab == 0
                                                ?  ShimmerClass.lineChartShimmer()
                                                :  ShimmerClass.barChartShimmer() ;
                                          } else if (state.weekWellWorkStatus is WeekWellWorkError) {
                                            final errorState = state.weekWellWorkStatus as WeekWellWorkError;
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
                                padding: EdgeInsets.only(right: 10.w,top: 10.h,bottom: 10.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("عملکرد پمپ چاه در هفته جاری",style: TextStyleP.f12Regular,),
                                    SizedBox(
                                      height: 10.h,
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
                                                border: Border.all(color: ColorPalette.lightGrey),
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
                                                    padding:  EdgeInsets.symmetric(vertical: 15.h),
                                                    decoration: BoxDecoration(
                                                      color: ColorPalette.lightGrey,
                                                      border: Border(bottom: BorderSide(color: ColorPalette.lightGrey)),
                                                    ),
                                                    child: const Row(
                                                      children: [
                                                        Expanded(flex:2,child: Text("روز/ تاریخ", textAlign: TextAlign.center)),
                                                        Expanded(flex:2,child: Text("ساعات کارکرد پمپ", textAlign: TextAlign.center)),
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
                                                  padding:  EdgeInsets.symmetric(vertical: 15.h),
                                                  decoration: BoxDecoration(
                                                    border: Border(bottom: BorderSide(color: ColorPalette.lightGrey, width: 1)),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(flex:2,
                                                        child: Text("${Constants().weekDayNames[dataIndex].name} ${currentDate.toString().toPersianDigit()} ",
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex:2,
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
                                      height: 10.h,
                                    ),
                                    BlocBuilder<WellDetailBloc, WellDetailState>(
                                      buildWhen: (previous, current) {

                                        if (builtOnce) return false;

                                        if (current.weekWellWorkStatus is WeekWellWorkSuccess) {
                                          builtOnce = true;
                                        }

                                        return true;
                                      },
                                      builder: (context, state) {
                                        if (state.weekWellWorkStatus is WeekWellWorkLoading) {
                                          return ShimmerClass.pieChartShimmer();
                                        }
                                        else if (state.weekWellWorkStatus is WeekWellWorkSuccess) {
                                          WeekWellWorkSuccess wellWorkSuccess = state.weekWellWorkStatus as WeekWellWorkSuccess;
                                          final dynamic on = wellWorkSuccess.currentWellWorkEntity.list.totalOn;
                                          final dynamic off = wellWorkSuccess.currentWellWorkEntity.list.totalOff;

                                          return Column(
                                            mainAxisSize: MainAxisSize.min, // جلوگیری از اشغال فضای اضافی
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                height: 200.h, // کاهش ارتفاع باکس چارت از 200 به 160
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    PieChart(
                                                      PieChartData(
                                                        sectionsSpace: 0,
                                                        centerSpaceRadius: 50.r, // کاهش شعاع داخلی از 80 به 55
                                                        sections: showingSections(
                                                          on: on,
                                                          off: off,
                                                        ),
                                                      ),
                                                      duration: const Duration(milliseconds: 150),
                                                      curve: Curves.linear,
                                                    ),
                                                    Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          "کل ساعات\n۱۶۸ ساعت",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyleP.f14Bold,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(height: 5.h),

                                              // راهنماها (Indicators)
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Expanded(
                                                          child: Indicator(
                                                            color: ColorPalette.darkGreen,
                                                            text: 'مجموع ساعات روشن بودن',
                                                            isSquare: false,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        Expanded(
                                                          child: Indicator(
                                                            color: ColorPalette.darkRed,
                                                            text: 'مجموع ساعات خاموش بودن',
                                                            isSquare: false,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Indicator(
                                                      color: ColorPalette.lightGrey,
                                                      text: 'مجموع ساعات هفته',
                                                      isSquare: false,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        } else if (state.weekWellWorkStatus is WeekWellWorkError) {
                                          WeekWellWorkError wellWorkError = state
                                              .weekWellWorkStatus as WeekWellWorkError;
                                          return Center(child: Text(wellWorkError.error));
                                        } else {
                                          return SizedBox();
                                        }
                                      },),


                                  ],
                                )),
                            SizedBox(height: 10.h),

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
                                          SizedBox(height: 25.h),
                                          BlocConsumer<WellDetailBloc, WellDetailState>(
                                            listenWhen: (previous, current) => previous.fingerStatus != current.fingerStatus,
                                            listener: (context, state) {
                                              final status = state.fingerStatus;

                                              if (status is FingerLoading || status is FingerRequestAccepted) {
                                                if (!_controller.isAnimating) {
                                                  _controller.reset();
                                                  _controller.forward();
                                                }
                                              }
                                              if (status is FingerRequestAccepted) {
                                                print("FingerRequestAccepted");

                                              }

                                              if (status is FingerSuccess) {
                                                // print("status.userLocalID${status.userLocalID}");
                                                BlocProvider.of<WellDetailBloc>(context).add(
                                                  ChangeUserLocalId(
                                                    status.userLocalID,
                                                  ),
                                                );
                                              }
                                              if (status is FingerSuccess || status is FingerError || status is FingerRequestFailed) {
                                                _controller.stop();
                                              }

                                              // if (status is FingerError) {
                                              //   ScaffoldMessenger.of(context).showSnackBar(
                                              //     SnackBar(
                                              //       content: Text(status.error.isNotEmpty ? status.error : "پاسخی از سمت دستگاه دریافت نشد."),
                                              //       backgroundColor: Colors.red,
                                              //       behavior: SnackBarBehavior.floating,
                                              //     ),
                                              //   );
                                              // }
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
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    const Text("دستگاه آماده است. لطفا اثر انگشت خود را روی سنسور بگذارید.",textAlign: TextAlign.start,),
                                                    SizedBox(height: 15.h),
                                                    _buildProgressBar(
                                                      showProgress: false,
                                                    ),
                                                    SizedBox(height: 15.h),
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
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text("در حال درخواست به دستگاه، لطفاً کمی منتظر بمانید...",textAlign: TextAlign.start,),
                                                    SizedBox(height: 15.h),

                                                    _buildProgressBar(),
                                                    SizedBox(height: 15.h),
                                                    _buildActionButton(
                                                      message: "",
                                                      isDisabled: true, // دکمه غیرفعال در زمان تایمر
                                                    ),
                                                  ],
                                                );
                                              }

                                              // ۴. حالت خطا یا پایان تایمر
                                              else if (fingerStatus is FingerError) {
                                                return Column(
                                                  children: [
                                                    Icon(Icons.error_outline_outlined,color: ColorPalette.darkRed,size: 70.sp,),
                                                    SizedBox(height: 15.h),

                                                    _buildActionButton(
                                                      message: "ارتباط با دستگاه برقرار نشد یا زمان به پایان رسید. لطفا مجددا درخواست دهید",
                                                      isDisabled: false, // فعال شدن مجدد دکمه
                                                    ),
                                                  ],
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
                                    SwitchPump(widget: widget),
                                    SizedBox(height: 32.h),

                                    ///signal
                                    SignalWidget(),
                                    SizedBox(height: 32.h),

                                    ///program
                                    Program(wellsDataEntity: widget.wellsDataEntity,),

                                  ],
                                )
                            );
                          },
                        );
                      },),
                  )

                ],
              ),
            )
        ),
      )
    );
  }

  // ویجت دکمه با قابلیت غیرفعال شدن (Disabled)
  Widget _buildActionButton({
    required String message,
    required bool isDisabled,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (message.isNotEmpty) ...[
            Text(message,style: TextStyleP.f12Regular),
             SizedBox(height: 50.h),
          ],
          GlobalElevatedButton(
            borderRadius: 2.5,
            widget:  Text("ثبت اثر انگشت",style: TextStyle(color: ColorPalette.black),),
            backColor: isDisabled ? ColorPalette.lightGrey :ColorPalette.darkBlue,
            // با پاس دادن null به onTap، دکمه غیرفعال می‌شود
            onTap: isDisabled ? null : _startProcess,
          ),
        ],
      ),
    );
  }

  // ویجت نوار پیشرفت تایمر
  Widget _buildProgressBar({bool showProgress = true}) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final totalSeconds = _controller.duration?.inSeconds ?? 0;
            final remainingSeconds =
            (totalSeconds * (1.0 - _controller.value)).ceil();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:showProgress? MainAxisAlignment.spaceBetween:MainAxisAlignment.center,
                  children: [
                    Text(
                      'برقراری ارتباط',
                      style: TextStyleP.f10Regular,
                    ),
                    SizedBox(width: 10.w,),
                    Text(
                      '${remainingSeconds.toString().toPersianDigit()} ثانیه',
                      style: TextStyleP.f10Regular,
                    ),
                  ],
                ),

                if (showProgress) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 15,
                    child: LinearProgressIndicator(
                      value: _controller.value,
                      borderRadius: BorderRadius.circular(15),
                      backgroundColor: const Color(0xffD3D9E0),
                      color: ColorPalette.darkBlue,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}




