import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/common/widgets/global_snackbar.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/features/report_feature/domain/usecase/get_capacity_usecase.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/report_flow_meter_status.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/well_report_status.dart';
import 'package:mahaliii/features/report_feature/presentation/widgets/volume_detail_report_widget.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/last_activity_usecase.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/flow_meter_usecase.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/time_picker_field.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../../../../locator.dart';
import '../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../../../auth_feature/presentation/screens/login_screen.dart';
import '../../../status_summary_feature/domain/entity/wells_data_entity.dart';
import '../../../status_summary_feature/domain/usecase/wells_list_usecase.dart';
import '../../../well_feature/domain/usecase/alert_count_usecase.dart';
import '../../../well_feature/domain/usecase/well_work_usecase.dart';
import '../bloc/report_bloc.dart';
import '../widgets/alert_report_widget.dart';
import '../widgets/key_index_widget.dart';
import '../widgets/last_activity.dart';
import '../widgets/pump_hours_widget.dart';
import '../widgets/volume_report_widget.dart';

class ReportScreen extends StatelessWidget {
   const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
  create: (context) {
    ReportBloc reportBloc =ReportBloc(locator<WellsListUseCase>(),
        locator<AlertCountUseCase>(),
        locator<WellFlowMeterUseCase>(),
      locator<GetCapacityUseCase>(),
      locator<WellWorkHourUseCase>(),
      locator<LastActivityUseCase>(),
    );
    reportBloc.add(StartReport());
    return reportBloc;
  },
  child: Padding(
        padding:  EdgeInsets.only(left: 16.w,right: 16.w,top: 50.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( "گزارش عملکرد دستگاه",style: TextStyleP.f16Medium,),
              SizedBox(height: 16.h),
              Text("برای دسترسی به اطلاعات مورد نظر خود، در کادرهای پایین فیلتر مورد نیاز خود را اعمال کنید.",style: TextStyleP.f12Regular),
              SizedBox(height: 24.h),

              ///well and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("انتخاب چاه"),
                        Container(
                          height: 50,
                          decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                          child: BlocConsumer<ReportBloc, ReportState>(
                            listener: (context, state) {
                              if(state.wellReportStatus is WellReportExit){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                },));
                              }
                            },
                            buildWhen: (previous, current) =>
                            previous.oneWell != current.oneWell ||
                                previous.wellReportStatus != current.wellReportStatus,
                            builder: (context, state) {
                              final status = state.wellReportStatus;

                              if (status is WellReportSuccess) {
                                // ۱. دریافت لیست آی‌دی‌های انتخاب شده فعلی از استیت برای مقداردهی اولیه
                                // نکته: برای initialValue، پکیج نیاز به خودِ آبجکت‌ها دارد، پس آن‌ها را فیلتر و پیدا می‌کنیم
                                final List<WellsDataEntity> initialSelectedObjects = status.wellsEntity
                                    .where((well) => well.data != null && (state.oneWell).contains(well.data!.deviceId))
                                    .map((well) => well.data!)
                                    .toList();

                                return MultiSelectDialogField<WellsDataEntity>(

                                  // 💡 ۲. محدود کردن ارتفاع دیالوگ به اندازه محتوا
                                  // با محاسبه تعداد آیتم‌ها، ارتفاع به صورت دینامیک تنظیم می‌شود
                                  dialogHeight: (status.wellsEntity.where((w) => w.data != null).length * 60.0).clamp(100.0, 400.0),
                                  selectedColor: ColorPalette.darkBlue,

                                  buttonText: Text(
                                    initialSelectedObjects.isEmpty
                                        ? "انتخاب چاه"
                                        : "${initialSelectedObjects.length} چاه",
                                  ),
                                  title: const SizedBox(), // مخفی کردن تایتل بالای دیالوگ
                                  chipDisplay: MultiSelectChipDisplay.none(), // مخفی کردن چیپ‌های زیر باکس
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.transparent), // مخفی کردن بوردر پیش‌فرض
                                  ),

                                  cancelText: const Text("بستن", style: TextStyle(color: Colors.black)),
                                  confirmText: const Text("تایید", style: TextStyle(color: Colors.black)),

                                  // ۲. تبدیل اطلاعات چاه‌ها به آیتم‌های قابل فهم برای پکیج
                                  items: status.wellsEntity
                                      .where((well) => well.data != null)
                                      .map((well) => MultiSelectItem<WellsDataEntity>(well.data!, well.data!.wellName.toString()))
                                      .toList(),

                                  initialValue: initialSelectedObjects,

                                  // ۳. گرفتن لیست آبجکت‌های انتخاب شده، تبدیل به آی‌دی (int) و ارسال به بلاک
                                  onConfirm: (values) {
                                    List<int> selectedIds = values.map((e) => e.deviceId!).toList();

                                    context.read<ReportBloc>().add(WellSelected(selectedIds));
                                  },
                                );
                              }

                              if (status is WellReportLoading) return ShimmerClass.shimmerContainer(height: 50);
                              if (status is WellReportError) return Center(child: Text(status.error));
                              return const SizedBox.shrink();
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("انتخاب تاریخ"),
                        BlocBuilder<ReportBloc, ReportState>(
                          buildWhen: (previous, current) => previous.startDate!=current.startDate ||
                              previous.endDate!=current.endDate,

                          builder: (context, state) {
                            final hasDate = state.startDate.isNotEmpty && state.endDate.isNotEmpty;
                            final displayText = hasDate ? "${state.endDate} - ${state.startDate}" : "انتخاب تاریخ";
                            return GestureDetector(
                            onTap: () async{
                              var picked = await showPersianDateRangePicker(
                              context: context,

                              firstDate: Jalali(1402, 1),
                              lastDate: Jalali.now(),
                              initialDate: Jalali.now(),
                              cancelText: "انصراف"
                            );
                            if (picked != null && context.mounted) {
                              String p(int n) => n.toString().padLeft(2, '0'); // یک تابع محلی کوچک برای پدینگ چپ
                              final start = "${picked.start.year}/${p(picked.start.month)}/${p(picked.start.day)}";
                              final end = "${picked.end.year}/${p(picked.end.month)}/${p(picked.end.day)}";

                              context.read<ReportBloc>().add(ChangeDate(start, end));
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration:  BoxDecoration(border: Border.all(color: Colors.grey)),

                            child: Center(child: Text(
                                displayText.toString().toPersianDigit())),
                          ),
                        );
                            },
                          )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 16.h),

              ///clock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //  فیلد ساعت شروع
                  BlocBuilder<ReportBloc, ReportState>(
                    buildWhen: (prev, curr) => prev.startHour != curr.startHour,
                    builder: (context, state) {
                      final displayStart = (state.startHour.isNotEmpty == true) ? state.startHour : "00:00";

                      return TimePickerField(
                        title: "ساعت شروع",
                        displayText: displayStart,
                        onTap: () async {
                          final picked = await Constants().showCustomTimePicker(context);
                          if (picked != null && context.mounted) {
                            String p(int n) => n.toString().padLeft(2, '0');
                            context.read<ReportBloc>().add(
                              ChangeStartClock("${p(picked.hour)}:${p(picked.minute)}"),
                            );
                          }
                        },
                      );
                    },
                  ),

                  const SizedBox(width: 10),

                  //  فیلد ساعت پایان
                  BlocBuilder<ReportBloc, ReportState>(
                    buildWhen: (prev, curr) =>
                    prev.endHour != curr.endHour || prev.startHour != curr.startHour,
                    builder: (context, state) {
                      final isStartEmpty = state.startHour.isEmpty;
                      final displayEnd = (state.endHour.isNotEmpty == true) ? state.endHour : "00:00";

                      return TimePickerField(
                        title: "ساعت پایان",
                        displayText: displayEnd,
                        ignoring: isStartEmpty,
                        onTap: () async {
                          final picked = await Constants().showCustomTimePicker(context);
                          if (picked != null && context.mounted) {
                            final parts = state.startHour.split(':');
                            final hours = int.parse(parts[0]);
                            final minutes = int.parse(parts[1]);

                            if ((picked.hour * 60 + picked.minute) > (hours * 60 + minutes)) {
                              String p(int n) => n.toString().padLeft(2, '0');
                              context.read<ReportBloc>().add(
                                ChangeEndClock("${p(picked.hour)}:${p(picked.minute)}"),
                              );
                            } else {
                              GlobalSnackBar.show(context, message: "ساعت پایان باید بزرگتر از ساعت شروع باشد");
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),

              ///search
              BlocBuilder<ReportBloc, ReportState>(
                builder: (context, state) {
                  final isFormValid = (state.startDate.isNotEmpty) &&
                      (state.endDate.isNotEmpty) && state.oneWell.isNotEmpty;


                  return GlobalElevatedButton(
                    height: 50,
                    width: double.infinity,
                    backColor: isFormValid ? ColorPalette.darkBlue : ColorPalette.inverseGrey,
                    widget: const Text("جستجو", style: TextStyle(color: Colors.black)),
                    onTap: isFormValid
                        ? () {
                      context.read<ReportBloc>()
                        ..add(SearchClicked())
                        ..add(ReportFlowMeter(FlowMeterParams(
                        page: 1,
                        type: 5,
                        endDate: state.endDate,
                        startDate: state.startDate,
                        ids: state.oneWell
                      ))) ..add(GetAlertCount(FlowMeterParams(
                          page: 1,
                          time: -1,
                          type: 5,
                          endDate: state.endDate,
                          startDate: state.startDate,
                          ids: state.oneWell
                      ))) ..add(ReportCommand(FlowMeterParams(
                          page: 1,
                          type: 5,
                          endDate: state.endDate,
                          startDate: state.startDate,
                          ids: state.oneWell
                      )))..add(UserActivityReportStart(FlowMeterParams(
                          page: 1,
                          type: 5,
                          endDate: state.endDate,
                          startDate: state.startDate,
                          ids: state.oneWell
                      )));

                    }
                        : () {
                      GlobalSnackBar.show(context, message: "تاریخ و چاه مورد نظر را انتخاب کنید");
                    },
                  );
                },
              ),
              SizedBox(height: 10),

              Text("شاخص های کلیدی برای بازه انتخابی",style: TextStyleP.f12Regular,),
              SizedBox(height: 10),

              KeyIndexWidget(),
              SizedBox(height: 10),

              BlocBuilder<ReportBloc, ReportState>(
                buildWhen: (prev, curr) =>
                prev.selectedReportIndex != curr.selectedReportIndex ||
                prev.reportFlowMeterStatus!=curr.reportFlowMeterStatus,
                builder: (context, state) {
                  // ۱. پیدا کردن امن آیتم انتخاب شده با لایه دفاعی برای جلوگیری از خطای نال
                  final selectedIndex = state.selectedReportIndex ?? 0;
                  final selectedItem = state.reportIndexList.isNotEmpty
                      ? state.reportIndexList[selectedIndex]
                      : null;

                  return IgnorePointer(
                    ignoring: state.reportFlowMeterStatus is ReportFlowMeterInitial,
                    child: Container(
                      width: MediaQuery.sizeOf(context).width / 2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: DropdownButton<AlertTypeEntity>(
                        underline: const SizedBox(),
                        isExpanded: true,
                        padding: EdgeInsets.only(right: 15.w, left: 5),
                        value: selectedItem,
                        items: state.reportIndexList.map((alert) {
                          // ۱. شرط غیرفعال بودن این آیتم خاص را بررسی می‌کنیم
                          final bool isItemDisabled =
                              ((state.flowMeterParams?.ids?.length ?? 1) == 1) && (alert.id == 1);

                          return DropdownMenuItem<AlertTypeEntity>(
                          value: alert,
                          //وظیفه اصلی: اجرای یک اکشن خاص و محلی برای همان آیتم (مثلاً باز کردن یک دیالوگ، پخش صدا، یا غیرفعال کردن کلیک).
                          onTap: isItemDisabled ? null : () {},
                          child: Text(alert.name,
                            style: TextStyle(
                              // ۳. تغییر رنگ متن به خاکستری برای نشان دادن وضعیت غیرفعال
                              color: isItemDisabled ? Colors.grey : Colors.black,
                            ),),
                        );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final bool isItemDisabled =
                                ((state.flowMeterParams?.ids?.length ?? 1) == 1) && (value.id == 1);

                            // اگر غیرفعال نبود، ایونت را ارسال کن
                            if (!isItemDisabled) {
                              context.read<ReportBloc>().add(OneReportIndexClicked(value));
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox( height: 10,
              ),

              BlocBuilder<ReportBloc, ReportState>(
                // buildWhen: (prev, curr) => prev.selectedReportIndex != curr.selectedReportIndex,
                builder: (context, state) {

                  switch (state.selectedReportIndex) {
                    case 0:
                      return Container(
                        decoration: Constants().whiteFiveRadiusDecoration,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("حجم مصرف ${state.oneWell?.wellName ?? ""}", style: TextStyleP.f12Regular),
                            const SizedBox(height: 10),
                             VolumeReportChartWidget(),
                          ],
                        ),
                      );
                      case 1:
                      return Container(
                        decoration: Constants().whiteFiveRadiusDecoration,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text("حجم مصرف ${state.oneWell?.wellName ?? ""}", style: TextStyleP.f12Regular),
                            const SizedBox(height: 10),
                             VolumeDetailReportChartWidget(),
                          ],
                        ),
                      );

                    case 2:
                      return Container(
                        decoration: Constants().whiteFiveRadiusDecoration,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ساعات کار پمپ", style: TextStyleP.f12Regular),
                            const SizedBox(height: 10),
                             PumpHoursChartWidget(),
                          ],
                        ),
                      );

                    case 3:
                      return Container(
                        decoration: Constants().whiteFiveRadiusDecoration,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("هشدارهای ارسال شده", style: TextStyleP.f12Regular),
                            const SizedBox(height: 10),
                             AlertsReportChartWidget(),
                          ],
                        ),
                      );

                    case 4:
                      return LastActivity();

                    default:
                      return const SizedBox.shrink();
                  }
                },
              )
            ],
          ),
        ),
      ),
    ));
  }


}

