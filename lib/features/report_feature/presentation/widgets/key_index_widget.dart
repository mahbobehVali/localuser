import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/shimmer_class.dart';
import '../../../../common/widgets/water_amount_container.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_command_status.dart';
import '../bloc/report_count_status.dart';
import '../bloc/report_flow_meter_status.dart';

class KeyIndexWidget extends StatelessWidget {
  const KeyIndexWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              if(state.reportFlowMeterStatus is ReportFlowMeterSuccess){
                ReportFlowMeterSuccess reportFlowMeterSuccess=state.reportFlowMeterStatus as ReportFlowMeterSuccess;
                return  WaterAmountContainer(title: "حجم کل آب مصرف شده",amount: reportFlowMeterSuccess.reportFlowMeter.list.total.toString());

              }else  if(state.reportFlowMeterStatus is ReportFlowMeterLoading){
                return ShimmerClass.shimmerContainer(height: 100);
              }else {
                return  WaterAmountContainer(title: "حجم کل آب مصرف شده",amount: "-",meter: false,);
              }

            },
          ),
          SizedBox(width: 5,),

          BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              if(state.reportCommandStatus is ReportCommandSuccess){
                ReportCommandSuccess reportCommandSuccess=state.reportCommandStatus as ReportCommandSuccess;
                return  WaterAmountContainer(title: "مجموع ساعات کارکرد پمپ ها",amount: "${reportCommandSuccess.reportFlowMeter.list.totalOn.toString()} ساعت",meter: false,);

              }else  if(state.reportCommandStatus is ReportCommandLoading){
                return ShimmerClass.shimmerContainer(height: 100);
              }else {
                return  WaterAmountContainer(title: "مجموع ساعات کارکرد پمپ ها",amount: "-",meter: false,);

              }
            },
          ),
          SizedBox(width: 5,),

          BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              if(state.reportCountStatus is ReportCountSuccess){
                ReportCountSuccess reportCountSuccess=state.reportCountStatus as ReportCountSuccess;
                return  WaterAmountContainer(title: "تعداد هشدارهای صادر شده",amount: reportCountSuccess.alertCountEntity.totalCount.toString(),meter: false,);

              }else  if(state.reportCountStatus is ReportCountLoading){
                return ShimmerClass.shimmerContainer(height: 100);
              }else {
                return  WaterAmountContainer(title: "تعداد هشدارهای صادر شده",amount: "-",meter: false,);

              }
            },
          ),
        ],
      ),
    );
  }
}