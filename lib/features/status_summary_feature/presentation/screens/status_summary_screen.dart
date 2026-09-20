import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/widgets/icon_container.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/status_summary_feature/domain/repository/status_summary_repository.dart';
import 'package:mahaliii/features/status_summary_feature/presentation/bloc/status_summary_bloc/last_activity_status.dart';

import '../../../../common/socket_repository.dart';
import '../../../../common/utils/constants.dart';
import '../../../../common/utils/sharedpreference.dart';
import '../../../../common/widgets/last_activity_widget.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../../../common/widgets/water_amount_container.dart';
import '../../../../config/color_palette.dart';
import '../../../../locator.dart';
import '../../../../main.dart';
import '../../domain/usecase/last_activity_usecase.dart';
import '../../domain/usecase/report_flowmeter_usecase.dart';
import '../../domain/usecase/wells_list_usecase.dart';
import '../bloc/status_summary_bloc/status_summary_bloc.dart';
import '../bloc/status_summary_bloc/water_status.dart';
import '../widgets/management_wells_widget.dart';
import '../widgets/summary_flow_meter_chart.dart';


class StatusSummaryScreen extends StatefulWidget {
  const StatusSummaryScreen({super.key});


  @override
  State<StatusSummaryScreen> createState() => _StatusSummaryScreenState();
}

class _StatusSummaryScreenState extends State<StatusSummaryScreen> with RouteAware{
  List<dynamic> info=[];
// ۱. تعریف متغیر برای نگهداری بلوک
  late StatusSummaryBloc _statusSummaryBloc;

  void loadUserData() async {
    List<dynamic> userInfo = await locator<SharedPrefOperator>().getUserInformationEntity();

    if (userInfo.isNotEmpty && mounted) {
      setState(() {
        info = userInfo;
      });


      // ۲. مقداردهی اولیه بلوک در initState
      _statusSummaryBloc..add(WellsListStart())..add(SocketEvent("area", int.parse(info[6])))
        ..add(ReportFlowMeter(FlowMeterParams(type: 1, ids: int.parse(info[6]))))..add(LastActivityStart(FlowMeterParams(type: 0, page: 1)))
      ;
    }
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ثبت نام صفحه در ناوبری
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    // حذف ثبت نام هنگام نابود شدن صفحه
    routeObserver.unsubscribe(this);
    _statusSummaryBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    locator<SocketRepository>().initAndConnect("manger");
    // ۱. ساخت BLoC به صورت مستقیم و بدون await در initState
    _statusSummaryBloc = StatusSummaryBloc(
      locator<WellsListUseCase>(),
      locator<LastActivityUseCase>(),
      locator<StatusSummaryRepository>(),
      locator<ReportFlowMeterUseCase>(),
      locator<SocketRepository>(),
    );
    loadUserData();
    // SocketRepository().initAndConnect("manger");
  }

  @override
  void didPopNext() {
    super.didPopNext();

    // ۴. حالا به راحتی هر دو ایونت را هنگام بازگشت کاربر صدا بزنید:
    if (info.isNotEmpty) {
      _statusSummaryBloc.add(
        ReportFlowMeter(
          FlowMeterParams(type: 1, ids: int.parse(info[6])),
        ),
      );

      _statusSummaryBloc.add(
        LastActivityStart(
          FlowMeterParams(type: 0, page: 1),
        ),
      );
    }
  }
  


  @override
  Widget build(BuildContext context) {

    if (info.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(

        body: BlocProvider<StatusSummaryBloc>.value(
          value: _statusSummaryBloc,
          child: Padding(
            padding:  EdgeInsets.only(left: 12.w,right: 12.w,top: 30.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text("خلاصه عملکرد چاه‌ها",style: TextStyleP.f16Bold),
                  SizedBox(height: 16.h),

                  Text("وضعیت مصرف آب همه چاه‌های تحت مدیریت",style: TextStyleP.f14Bold),
                  ///socket water
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      // باکس ۱: حجم آب مصرفی تا این لحظه

                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: ColorPalette.inverseGrey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, // وسط‌چین افقی
                            children: [
                              Row(
                                children: [
                                  IconContainer(icon: Image.asset("assets/icons/flowmeter.png"),color: ColorPalette.lightBlue,),
                                  SizedBox(width: 5.w,),
                                  Text(
                                    "امروز",
                                    style: TextStyleP.f14Bold,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                                    builder: (context, state) {
                                      if (state.waterStatus is WaterSuccess) {
                                        final waterSuccess = state.waterStatus as WaterSuccess;
                                        final totalValue = waterSuccess.waterData?.today ?? 0;

                                        if (waterSuccess.waterData == null) return const SizedBox();
                                        String formattedValue = NumberFormat.decimalPattern('fa').format(totalValue.toDouble().round());

                                        return Text(
                                          "\u200E$formattedValue m³",
                                          style: TextStyleP.f16Bold,
                                          textAlign: TextAlign.center,
                                        );
                                      } else if (state.waterStatus is WaterLoading) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: SizedBox(
                                              width: 80.w,
                                              child: ShimmerClass.shimmerContainer(height: 20)),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w,),

                      // باکس ۲: حجم آب مصرفی این ماه
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: ColorPalette.inverseGrey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, // وسط‌چین افقی
                            children: [
                              Row(
                                children: [
                                  IconContainer(icon: Image.asset("assets/icons/flowmeter.png"),color: ColorPalette.lightBlue,),
                                  SizedBox(width: 5.w,),
                                  Text(
                                    "این ماه",
                                    style: TextStyleP.f14Bold,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                                    builder: (context, state) {
                                      if (state.waterStatus is WaterSuccess) {
                                        final waterSuccess = state.waterStatus as WaterSuccess;
                                        final monthlyValue = waterSuccess.waterData?.monthly ?? 0;

                                        if (waterSuccess.waterData == null) return const SizedBox();
                                        String formattedValue = NumberFormat.decimalPattern('fa').format(monthlyValue.toDouble().round());

                                        return Text(
                                          "\u200E$formattedValue m³",
                                          style: TextStyleP.f16Bold,
                                          textAlign: TextAlign.center,
                                        );
                                      } else if (state.waterStatus is WaterLoading) {
                                        return Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: SizedBox(
                                              width: 80.w,
                                              child: ShimmerClass.shimmerContainer(height: 20)),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: ColorPalette.inverseGrey),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center, // وسط‌چین افقی
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.w, top: 10.h),
                          child: Row(

                            children: [
                              IconContainer(icon: Image.asset("assets/icons/flowmeter.png"),color: ColorPalette.lightBlue,),
                              SizedBox(width: 5.w,),
                              Text(
                                "از ابتدای سال",
                                style: TextStyleP.f14Bold,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Stack(
                          children: [
                            Image.asset("assets/icons/group.png"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                // textDirection: TextDirection.LTR!, // اجبار جهت راست‌به‌چپ برای چینش
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.w, top: 10.h),
                                    child: BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                                      builder: (context, state) {
                                        if (state.waterStatus is WaterSuccess) {
                                          final waterSuccess = state.waterStatus as WaterSuccess;
                                          final totalValue = waterSuccess.waterData?.total ?? 0;

                                          if (waterSuccess.waterData == null) return const SizedBox();
                                          String formattedValue = NumberFormat.decimalPattern('fa').format(totalValue.toDouble().round());

                                          return Text(
                                            "\u200E$formattedValue m³",
                                            style: TextStyleP.f16Bold,
                                            textAlign: TextAlign.center,
                                          );
                                        } else if (state.waterStatus is WaterLoading) {
                                          return SizedBox(
                                              width: 80.w,
                                              child: ShimmerClass.shimmerContainer(height: 20));
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                  //   builder: (context, state) {
                  //     if (state.waterStatus is WaterSuccess) {
                  //       final waterSuccess = state.waterStatus as WaterSuccess;
                  //
                  //       if (waterSuccess.waterData != null) {
                  //         return Column(
                  //
                  //           children: [
                  //
                  //             Row(
                  //               children: [
                  //
                  //
                  //                 Expanded(
                  //                   child: WaterAmountContainer(
                  //                     image: "assets/icons/flowmeter.png",
                  //
                  //                     title: "امروز",
                  //                     amount:"${NumberFormat.decimalPattern().format(waterSuccess.waterData!.today!.toDouble().round())} m³",
                  //                   ),
                  //                 ),
                  //
                  //                  SizedBox(width: 8.w),
                  //                 Expanded(
                  //                   child: WaterAmountContainer(
                  //                     image: "assets/icons/flowmeter.png",
                  //
                  //                     title: "این ماه",
                  //                     amount:"${NumberFormat.decimalPattern().format(waterSuccess.waterData!.monthly!.toDouble().round())} m³",
                  //                   ),
                  //                 ),
                  //
                  //               ],
                  //             ),
                  //              SizedBox(height: 8.h),
                  //             WaterAmountContainer(
                  //               image: "assets/icons/flowmeter.png",
                  //               title: "از ابتدای سال",
                  //               amount:"${NumberFormat.decimalPattern().format(waterSuccess.waterData!.total!.toDouble().round())} m³",
                  //               year: true,
                  //
                  //             ),
                  //           ],
                  //         );
                  //       } else {
                  //         return const SizedBox();
                  //       }
                  //     }
                  //     else if (state.waterStatus is WaterLoading) {
                  //       return ShimmerClass.shimmerListviewHor(height: 100);
                  //     }else if (state.waterStatus is WaterError) {
                  //       return Center(child: Text((state.waterStatus as WaterError).error),);
                  //     } else {
                  //       return const SizedBox();
                  //     }
                  //   },
                  // ),
                  SizedBox(height: 16.h),

                  ///chart
                  SummaryFlowMeterChart(info: info),
                  SizedBox(height: 16.h,),
                  ///wellsList
                  ManagementWellsWidget(),
                  SizedBox(height: 16.h,),

                  Container(
                  padding: EdgeInsets.all(12),
                  decoration: Constants().whiteFiveRadiusDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("آخرین فعالیت های انجام شده",style: TextStyleP.f14Medium),
                      SizedBox(height: 10.h),

                      BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                        buildWhen: (previous, current) => previous.selectedPage!=current.selectedPage ||
                            previous.lastActivityStatus!=current.lastActivityStatus,

                        builder: (context, state) {
                          if(state.lastActivityStatus is LastActivitySuccess){
                            LastActivitySuccess lastActivitySuccess=state.lastActivityStatus as LastActivitySuccess;
                            return Column(
                              children: [
                                LastActivityWidget(lastActivityEntity: lastActivitySuccess.lastActivityEntity,report: false,),
                                PaginationWidget(selected: state.selectedPage,
                                    lastPage: lastActivitySuccess.lastActivityEntity.lastPage!,
                                    onPageChanged: (newPage) {
                                      // هرکدام از دکمه‌ها کلیک شوند، شماره صفحه درست (قبل، بعد یا شماره دقیق) به اینجا فرستاده می‌شود
                                      BlocProvider.of<StatusSummaryBloc>(context).add(
                                        LastActivityStart(
                                          FlowMeterParams(page: newPage),
                                        ),
                                      );
                                    }
                                )
                              ],
                            );
                          }
                          else if(state.lastActivityStatus is LastActivityLoading){
                            return ShimmerClass.shimmerListviewVertical(height: 40,count: 4);

                          }else if(state.lastActivityStatus is LastActivityEmpty){
                            return Constants.noData();

                          }else if(state.lastActivityStatus is LastActivityError){
                            LastActivityError lastActivityError=state.lastActivityStatus as LastActivityError;
                            return Center(child: Text(lastActivityError.error));

                          }else{
                            return Center(child: SizedBox());
                          }
                        },
                      ),
                    ],
                  ),
                ),
                ]
              )
              ),
            ),
      ),
      )
    );
  }
}
