import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/status_summary_feature/domain/repository/status_summary_repository.dart';
import 'package:mahaliii/features/status_summary_feature/presentation/bloc/status_summary_bloc/last_activity_status.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/socket_repository.dart';
import '../../../../common/utils/constants.dart';
import '../../../../common/utils/sharedpreference.dart';
import '../../../../common/widgets/last_activity_widget.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../../../common/widgets/water_amount_container.dart';
import '../../../../locator.dart';
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

class _StatusSummaryScreenState extends State<StatusSummaryScreen> {
  List<dynamic> info=[];

  void loadUserData() async {
    List<dynamic> userInfo = await locator<SharedPrefOperator>().getUserInformationEntity();

    if (userInfo.isNotEmpty) {
      setState(() {
        info= userInfo;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
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

        body: BlocProvider<StatusSummaryBloc>(
          create: (context) {
            StatusSummaryBloc statusSummaryBloc= StatusSummaryBloc(
              locator<WellsListUseCase>(),
              locator<LastActivityUseCase>(),
              locator<StatusSummaryRepository>(),
              locator<ReportFlowMeterUseCase>(),
              locator<SocketRepository>(),
            );
            statusSummaryBloc
              ..add(WellsListStart())
              ..add(SocketEvent("area",int.parse(info[6])))
              ..add(ReportFlowMeter(FlowMeterParams(
                  type: 0,
                  ids:[int.parse(info[6])],
              )))
              ..add(LastActivityStart(FlowMeterParams(
                type: 0,
                  page:1,
                  )));
            return statusSummaryBloc;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text("خلاصه عملکرد چاه‌ها",style: TextStyleP.f16Medium),
                  SizedBox(height: 16.h),
                  ///socket water

                  BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                    builder: (context, state) {
                      if (state.waterStatus is WaterSuccess) {
                        final waterSuccess = state.waterStatus as WaterSuccess;

                        if (waterSuccess.waterData != null) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                WaterAmountContainer(
                                  title: "حجم کل آب مصرف شده",
                                  amount: waterSuccess.waterData!.total!.toString(),
                                ),
                                const SizedBox(width: 8),
                                WaterAmountContainer(
                                  title: "حجم آب مصرف شده ماه",
                                  amount: waterSuccess.waterData!.monthly!.toString(),
                                ),
                                const SizedBox(width: 8),
                                WaterAmountContainer(
                                  title: "حجم آب مصرف شده امروز",
                                  amount: waterSuccess.waterData!.today!.toString(),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      } else if (state.waterStatus is WaterLoading) {
                        return ShimmerClass.shimmerListviewHor(height: 100);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
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
                      Text("آخرین فعالیت های انجام شده",style: TextStyleP.f12Regular),
                      SizedBox(height: 10.h),

                      BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                        buildWhen: (previous, current) => previous.selectedPage!=current.selectedPage ||
                            previous.lastActivityStatus!=current.lastActivityStatus,

                        builder: (context, state) {
                          if(state.lastActivityStatus is LastActivitySuccess){
                            LastActivitySuccess lastActivitySuccess=state.lastActivityStatus as LastActivitySuccess;
                            return Column(
                              children: [
                                LastActivityWidget(lastActivityEntity: lastActivitySuccess.lastActivityEntity),
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
