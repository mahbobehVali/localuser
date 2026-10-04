import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../bottom_nav/wrapper_bloc.dart';
import '../../../../../common/widgets/global_snackbar.dart';
import '../../../../../common/widgets/icon_container.dart';
import '../../../../../common/widgets/show_dialogs.dart';
import '../../../../../config/color_palette.dart';
import '../../bloc/well_detail_bloc/on_off_status.dart';
import '../../bloc/well_detail_bloc/well_detail_bloc.dart';
import '../well_detail_screen.dart';

class SwitchPump extends StatelessWidget {
  const SwitchPump({
    super.key,
    required this.widget,
  });

  final WellDetailScreen widget;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
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
          BlocConsumer<WellDetailBloc, WellDetailState>(
            // 1. شرط برای نمایش اسنک‌بار
            listenWhen: (previous, current) =>
            previous.isSwitched != current.isSwitched ||
                previous.onOffStatus != current.onOffStatus,
            listener: (context, state) {
              if (state.onOffStatus is OnOffSuccess) {
                final isSuccess = state.onOffStatus as OnOffSuccess;
                final wrapperState = context.read<WrapperBloc>().state;

                final bool exists = wrapperState.wells.any(
                      (well) => well.data?.deviceId == isSuccess.offEntity.deviceId,
                );

                if (exists) {
                  GlobalSnackBar.show(
                    context,
                    message: state.isSwitched == true
                        ? "${isSuccess.offEntity.name} روشن شد"
                        : "${isSuccess.offEntity.name} خاموش شد",
                    duration: 2,
                  );
                }
              }
            },

            // 2. شرط برای ری‌بیلد شدن UI سوییچ
            buildWhen: (previous, current) => previous.isSwitched != current.isSwitched,
            builder: (context, state) {
              // 🟢 اینجا state به راحتی در دسترس است
              return Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  CupertinoSwitch(
                    activeTrackColor: ColorPalette.lightBlue,
                    thumbColor: ColorPalette.darkBlue,
                    inactiveThumbColor: ColorPalette.black.withValues(alpha: 0.5),
                    value: state.isSwitched,
                    onChanged: (value) {
                      ShowDialogs().turnPomp(
                        context,
                        BlocProvider.of<WellDetailBloc>(context),
                        value,
                        widget.wellsDataEntity,
                      );
                    },
                  ),
                  Text(
                    state.isSwitched == true ? "روشن" : "خاموش",
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}