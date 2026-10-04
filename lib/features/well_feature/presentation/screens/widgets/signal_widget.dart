import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/utils/constants.dart';
import '../../../../../common/widgets/icon_container.dart';
import '../../../../../common/widgets/signal_chart.dart';
import '../../../../../config/color_palette.dart';
import '../../bloc/well_detail_bloc/flowmeter_today_status.dart';
import '../../bloc/well_detail_bloc/well_detail_bloc.dart';

class SignalWidget extends StatelessWidget {
  const SignalWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: ColorPalette.white,
          borderRadius: BorderRadius.circular(8),
        ),

        child:BlocBuilder<WellDetailBloc, WellDetailState>(
          buildWhen: (previous, current) {
            return previous.signalStatus != current.signalStatus ||
              previous.signal != current.signal;
          },
          builder: (context, state) {
            if (state.signalStatus is SignalSuccess) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconContainer(
                            icon: const Icon(Icons.signal_cellular_alt),
                            color: ColorPalette.iconContainerColor,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 9),
                          const Text("وضعیت آنتن دهی دستگاه"),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(Constants().signalLevel[state.signal].name),
                    ],
                  ),
                  SignalBarChart(value: state.signal),
                ],
              );
            } else if (state.signalStatus is SignalError) {
              final signalError = state.signalStatus as SignalError;
              return Center(child: Text(signalError.error));
            }

            return const SizedBox();
          },
        )
    );
  }
}