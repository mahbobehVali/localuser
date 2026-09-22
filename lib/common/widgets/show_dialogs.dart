import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/alert_filter_params.dart';
import 'package:mahaliii/common/params/change_password_params.dart';
import 'package:mahaliii/common/params/create_time_params.dart';
import 'package:mahaliii/common/widgets/global_snackbar.dart';
import 'package:mahaliii/common/widgets/refuse_button.dart';
import 'package:mahaliii/common/widgets/show_snack_bar.dart';
import 'package:mahaliii/common/widgets/sign_up_image.dart';
import 'package:mahaliii/common/widgets/time_picker_field.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_type_entity.dart';
import 'package:mahaliii/features/alert_feature/presentation/bloc/alert_well_list_status.dart';
import 'package:mahaliii/features/auth_feature/presentation/screens/login_screen.dart';
import 'package:mahaliii/features/panel_feature/presentation/bloc/account_bloc.dart';
import 'package:mahaliii/features/panel_feature/presentation/bloc/change_password_status.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_data_entity.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_entity.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/send_support_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_bloc.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/create_time_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/delete_time_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/well_detail_bloc.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../features/alert_feature/presentation/bloc/alert_bloc.dart';
import '../../features/panel_feature/presentation/cubit/logout_cubit.dart';
import '../../features/well_feature/domain/entity/program_day_entity.dart';
import '../../features/well_feature/presentation/bloc/well_detail_bloc/on_off_status.dart';
import '../params/send_new_request_to_support_params.dart';
import '../utils/constant_texts.dart';
import '../utils/constants.dart';
import 'bottom_sheets.dart';
import 'clock_box.dart';
import 'global_elevated_button.dart';
import 'image_converter.dart';

class ShowDialogs {
  int timeToMinutes(String timeStr) {
    // فرض می‌کنیم فرمت ساعت "HH:mm" یا "HH:mm:ss" است
    final parts = timeStr.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return (hours * 60) + minutes;
  }

  bool checkConflictForDay({
    required List<ProgramDayEntity> programDayEntity,
    required String targetDayName, // نام روزی که کاربر انتخاب کرده (مثلاً "یکشنبه")
    required String newStart,
    required String newEnd,
  }) {
    // ۱. تبدیل ساعت‌ها به دقیقه برای مقایسه راحت‌تر
    int timeToMinutes(String timeStr) {
      final parts = timeStr.split(':');
      return (int.parse(parts[0]) * 60) + int.parse(parts[1]);
    }

    final int newStartMin = timeToMinutes(newStart);
    final int newEndMin = timeToMinutes(newEnd);

    // ۲. پیدا کردن روز مورد نظر در لیست بر اساس dayName
    // از try-catch یا ordinary loop استفاده می‌کنیم که اگر روز پیدا نشد خطا ندهد
    final targetDay = programDayEntity.firstWhere(
          (day) => day.dayName == targetDayName,
      orElse: () => ProgramDayEntity(targetDayName, []), // اگر روزی نبود یک لیست خالی فرض کن
    );

    // ۳. اگر روز پیدا شد یا بازه‌ای داشت، تداخل تک‌تک سانس‌ها را چک کن
    if (targetDay.periods != null) {
      for (var period in targetDay.periods!) {
        if (period.startTime == null || period.endTime == null) continue;

        final int existingStartMin = timeToMinutes(period.startTime!);
        final int existingEndMin = timeToMinutes(period.endTime!);

        // فرمول طلایی تداخل: (شروع جدید < پایان قدیمی) و (پایان جدید > شروع قدیمی)
        if (newStartMin < existingEndMin && newEndMin > existingStartMin) {
          return true; // ❌ تداخل وجود دارد!
        }
      }
    }

    return false; //  هیچ تداخلی وجود ندارد و جاده صاف است!
  }

  Future<void> changePasswordShowDialog({
    required BuildContext context,
    required AccountBloc panelBloc,
    required String newPass,
    required String previousPass,
    required int serverId,
  }) {
     const maxSeconds=120;

    int seconds = maxSeconds;
    Timer? timer;
    TextEditingController code=TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateInDialog) {

            // شروع تایمر
            timer ??= Timer.periodic(Duration(seconds: 1), (t) {
                // مهم‌ترین بخش: چک کردن mounted
                // اگر دیالوگ بسته شده باشد، setState را اجرا نکن
                if (seconds > 0) {
                  if (context.mounted) { // <--- این خط حیاتی است
                    setStateInDialog(() {
                      seconds--;
                    });
                  }
                } else {
                  t.cancel();
                }
              });

            return BlocProvider.value(
              value:panelBloc,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(

                  content: SizedBox(
                    height: 300.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("آیا اطمینان دارید که می‌خواهید تغییرات را ذخیره نمایید؟\nبرای تایید تغییرات لطفا کد تایید پیامک شده به شماره تماس خود را در کادر زیر وارد نمایید"),
                        SizedBox(height: 34.h),
                        Text("کد تایید"),
                        SizedBox(height: 10.h),

                        TextFormField(
                          controller: code,
                        ),
                        SizedBox(height: 10.h),

                        Text("زمان باقی مانده ${seconds.toString().toPersianDigit()} ",style: TextStyle(
                            fontSize: 10.sp
                        ),)
                      ],
                    ),
                  ),
                  actions: [
                    GlobalElevatedButton(
                        onTap: () {
                          panelBloc.add(ChangePasswordEvent(ChangePasswordParams(
                            serverId: serverId,
                            newPassword: newPass,
                            oldPassword: previousPass,
                            code: int.parse(code.text)
                          )));
                        },
                        widget: BlocConsumer<AccountBloc, AccountState>(
                        listener: (context, state) {
                          if(state.changePasswordStatus is ChangePasswordSuccess){
                            Navigator.of(context).pop();
                            GlobalSnackBar.show(context,message: "رمز عبور با موفقیت تغییر کرد");

                          }

                          if(state.changePasswordStatus is ChangePasswordError){
                            Navigator.of(context).pop();

                            ChangePasswordError changePasswordError=state.changePasswordStatus as ChangePasswordError;
                            GlobalSnackBar.show(context,message: changePasswordError.error);

                          }

                          if(state.changePasswordStatus is ChangePasswordExit){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            },));
                          }
                        },
                        builder: (context, state) {
                          return state.changePasswordStatus is ChangePasswordLoading?Center(
                            child: CircularProgressIndicator(),
                          ):
                          Text("ذخیره",style: TextStyle(color: Colors.black));
                        },
                      ),backColor: ColorPalette.darkBlue,
                        width: MediaQuery.sizeOf(context).width*0.30),
                    GlobalElevatedButton(widget: Text("لغو",style: TextStyle(color: Colors.black),),backColor: Color(0xffB7BFCC),width: MediaQuery.sizeOf(context).width*0.30,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),

                  ],
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      // اگر کاربر با زدن بیرون از دیالوگ آن را بست، تایمر اینجا کنسل شود
      timer?.cancel();
    });
  }


  Future<void> newTimeCreate({
    required BuildContext context,
    required WellDetailBloc wellDetailBloc,
    required WellsDataEntity wellsDataEntity,
    required List<ProgramDayEntity> programDayEntity

  }) {


    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: wellDetailBloc,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(

              backgroundColor: Colors.white,
              content: SizedBox(
                height: 400.h,
                width: MediaQuery.of(context).size.width, // برای تنظیم ابعاد
                child: Scaffold(
                  backgroundColor: Colors.transparent,

                  body: Builder(
                    builder: (scaffoldContext) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("برنامه زمانی ${wellsDataEntity.wellName}",style: TextStyleP.f14Medium,),
                          SizedBox(height: 14.h),

                          Text("انتخاب روز"),
                          BlocBuilder<WellDetailBloc, WellDetailState>(
                            builder: (context, state) {
                              return Wrap(
                                direction:Axis.horizontal,
                                children: List.generate(Constants().weekDayNames.length, (index) {

                                  // اصلاح این قسمت: اگر id برابر با -1 بود، هیچ‌کدام را انتخاب نکن (false برگردان)
                                  final bool isSelected = state.daySelected.id == -1
                                      ? false
                                      : state.daySelected.id == Constants().weekDayNames[index].id;

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 5,left: 5),
                                    child: GestureDetector(
                                        onTap: () {
                                          BlocProvider.of<WellDetailBloc>(context).add(
                                              DayClicked(Constants().weekDayNames[index]));

                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          width: 70.w,
                                          height: 40.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: isSelected ? Colors.grey[400] : Colors.white,
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                              color:  Colors.grey.shade700,
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            Constants().weekDayNames[index].name,
                                          ),
                                        )
                                    ),
                                  );

                                },),
                              );
                            },
                          ),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //  فیلد ساعت شروع
                              BlocBuilder<WellDetailBloc, WellDetailState>(
                                buildWhen: (prev, curr) => prev.startHour != curr.startHour ||
                                    prev.daySelected != curr.daySelected,
                                builder: (context, state) {
                                  final displayStart = (state.startHour?.isNotEmpty == true) ? state.startHour! : "";

                                  return TimePickerField(
                                    title: "ساعت شروع",
                                    displayText: displayStart,
                                    ignoring: false,
                                    // ignoring: state.daySelected.id == -1,
                                    onTap: () async {
                                      final picked = await Constants().showCustomTimePicker(context);
                                      if (picked != null && context.mounted) {
                                        String p(int n) => n.toString().padLeft(2, '0');
                                        context.read<WellDetailBloc>().add(
                                          ChangeStartClock("${p(picked.hour)}:${p(picked.minute)}"),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),

                               SizedBox(width: 10.w),

                              // 🕒 فیلد ساعت پایان
                              BlocBuilder<WellDetailBloc, WellDetailState>(
                                buildWhen: (prev, curr) =>
                                prev.endHour != curr.endHour || prev.startHour != curr.startHour || curr.daySelected != prev.daySelected,
                                builder: (context, state) {
                                  final isStartEmpty = state.startHour?.isEmpty ?? true;
                                  final displayEnd = (state.endHour?.isNotEmpty == true) ? state.endHour! : "";

                                  return TimePickerField(
                                    title: "ساعت پایان",
                                    displayText: displayEnd,
                                    ignoring: isStartEmpty,
                                    onTap: () async {
                                      final picked = await Constants().showCustomTimePicker(context);
                                      if (picked != null && context.mounted) {
                                        final parts = state.startHour!.split(':');
                                        final hours = int.parse(parts[0]);
                                        final minutes = int.parse(parts[1]);

                                        if ((picked.hour * 60 + picked.minute) > (hours * 60 + minutes)) {
                                          String p(int n) => n.toString().padLeft(2, '0');
                                          context.read<WellDetailBloc>().add(
                                            ChangeEndClock("${p(picked.hour)}:${p(picked.minute)}"),
                                          );
                                        } else {
                                          GlobalSnackBar.show(scaffoldContext, message: "ساعت پایان باید بزرگتر از ساعت شروع باشد");
                                        }
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 30.h),

                          BlocConsumer<WellDetailBloc, WellDetailState>(
                            listenWhen: (previous, current) {
                              // هر زمان که وضعیت onOffStatus تغییر کند (چه خطا، چه موفقیت)، لیسنر فعال می‌شود
                              return previous.createTimeStatus != current.createTimeStatus;
                            },
                            listener: (blocContext, state) {
                              // 💡 ۱. در صورت موفقیت
                              if (state.createTimeStatus is CreateTimeSuccess) {
                                CreateTimeSuccess createTimeSuccess=state.createTimeStatus as CreateTimeSuccess;
                                // پاک کردن اسنک‌بارهای قبلی
                                ScaffoldMessenger.of(context).clearSnackBars();

                                // نمایش اسنک‌بار سبز موفقیت
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text(createTimeSuccess.status==1?  "برنامه با موفقیت ثبت شد":"پاسخی از سمت دستگاه دریافت نشد"),
                                //     backgroundColor: Colors.green,
                                //     duration: const Duration(seconds: 3),
                                //   ),
                                // );
                                GlobalSnackBar.show(context, message: createTimeSuccess.status==1?  "برنامه با موفقیت ثبت شد":"پاسخی از سمت دستگاه دریافت نشد");

                                // بستن دیالوگ
                                Navigator.of(dialogContext).pop();
                              }

                              // 💡 ۲. در صورت خطا یا تایم‌اوت
                              if (state.createTimeStatus is CreateTimeError) {
                                final errorState = state.createTimeStatus as CreateTimeError;

                                // پاک کردن اسنک‌بارهای قبلی
                                ScaffoldMessenger.of(context).clearSnackBars();

                                // نمایش اسنک‌بار قرمز خطا
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorState.error),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );

                                // // ریست کردن استاتوس جهت جلوگیری از اجرای تکراری
                                wellDetailBloc.add(ResetCreateTimeStatus());
                              }
                            },
                          builder: (context, state) {
                            final isLoading= state.createTimeStatus is CreateTimeLoading;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (isLoading) ...[
                                  const CountdownTimerWidget(durationInSeconds: 60),
                                ],
                                Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(

                                    child: GlobalElevatedButton(
                                      borderRadius: 2.5,
                                      backColor: Colors.grey[300]!,
                                      onTap:  () {

                                        wellDetailBloc.add(DayClicked(AlertTypeEntity("",-1)));
                                        if(state.startHour!.isNotEmpty ) {
                                          wellDetailBloc.add(ChangeStartClock(""));
                                        }
                                        if(state.endHour!.isNotEmpty ) {
                                          wellDetailBloc.add(ChangeEndClock(""));
                                        }
                                        Navigator.of(dialogContext).pop();
                                      },
                                      widget: const Text("انصراف", style: TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                      flex:2,
                                      child: GlobalElevatedButton(
                                        borderRadius: 2.5,
                                    backColor: ColorPalette.darkBlue,
                                    widget: state.createTimeStatus is CreateTimeLoading?
                                  CircularProgressIndicator(): Text("ثبت زمان",style: TextStyle(color: ColorPalette.black),),
                                    onTap:(state.daySelected.id==-1) ||
                                        state.startHour!.isEmpty || state.endHour!.isEmpty ? (){
                                      GlobalSnackBar.show(scaffoldContext, message: "روز هفته و ساعت شروع و پایان را مشخص کنید");

                                    }:isLoading? null:() {
                                      bool hasConflict = checkConflictForDay(programDayEntity: programDayEntity,
                                          targetDayName: state.daySelected.name, newStart: state.startHour!, newEnd: state.endHour!);
                                      if (hasConflict) {
                                        Navigator.of(context).pop();
                                        GlobalSnackBar.show(scaffoldContext, message: "این زمان با برنامه‌های قبلی این روز تداخل دارد!");
                                      } else {
                                        wellDetailBloc.add(CreateNewTime(CreateTimeParams(
                                            code: wellsDataEntity.code,
                                            pin: wellsDataEntity.pin,
                                            deviceID: wellsDataEntity.deviceId,
                                            userLocalID: wellsDataEntity.userLocalId,
                                            startTime: state.startHour,
                                            endTime: state.endHour,
                                            weekDay: state.daySelected.id,
                                          id: wellsDataEntity.id

                                        )));
                                      }
                                    },))
                                ],
                                  ),
                              ],
                            );
                                },
                              )
                        ],
                      );
                    }
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    //     .then((_) {
    // });
  }

  Future<void> deleteClock({
    required BuildContext context,
    required WellDetailBloc wellDetailBloc,
    required WellsDataEntity wellsDataEntity,
    required String startTime,
    required String endTime,
    required String dayName,
    required int userLocalId,
    required int day,
  }) {

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {

            return BlocProvider.value(
              value: wellDetailBloc,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(

                  backgroundColor: Colors.white,

                  content: SizedBox(
                    height: 300.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("برنامه زمانی ${wellsDataEntity.wellName}"),
                        SizedBox(height: 14,),

                        Text("آیا اطمینان دارید که می‌خواهید زمان مورد نظر خود را حذف کنید؟"),
                        SizedBox(height: 14.h),
                        Text("روز $dayName"),
                        SizedBox(height: 14.h),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: ClockBox(clock:"ساعت شروع",time: startTime,)),
                            Expanded(child: ClockBox(clock:"ساعت پایان",time: endTime,)),
                          ],
                        ),
                        SizedBox(height: 20.h),

                        BlocConsumer<WellDetailBloc, WellDetailState>(
                          listenWhen: (previous, current) {
                            // هر زمان که وضعیت onOffStatus تغییر کند (چه خطا، چه موفقیت)، لیسنر فعال می‌شود
                            return previous.deleteTimeStatus != current.deleteTimeStatus;
                          },
                          listener: (blocContext, state) {
                            // 💡 ۱. در صورت موفقیت
                            if (state.deleteTimeStatus is DeleteTimeSuccess) {
                              DeleteTimeSuccess deleteTimeSuccess=state.deleteTimeStatus as DeleteTimeSuccess;
                              // پاک کردن اسنک‌بارهای قبلی
                              ScaffoldMessenger.of(context).clearSnackBars();

                              // نمایش اسنک‌بار سبز موفقیت
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //
                              //     content: Text(deleteTimeSuccess.status==1?  "برنامه با موفقیت حذف شد":"پاسخی از سمت دستگاه دریافت نشد"),
                              //     backgroundColor:deleteTimeSuccess.status==1? ColorPalette.darkGreen:ColorPalette.darkRed,
                              //     duration: const Duration(seconds: 3),
                              //   ),
                              // );
                              GlobalSnackBar.show(context, message: deleteTimeSuccess.status==1?  "برنامه با موفقیت حذف شد":"پاسخی از سمت دستگاه دریافت نشد");

                              // بستن دیالوگ
                              Navigator.of(dialogContext).pop();
                            }

                            // 💡 ۲. در صورت خطا یا تایم‌اوت
                            if (state.deleteTimeStatus is DeleteTimeError) {
                              final errorState = state.deleteTimeStatus as DeleteTimeError;

                              // پاک کردن اسنک‌بارهای قبلی
                              ScaffoldMessenger.of(context).clearSnackBars();

                              // نمایش اسنک‌بار قرمز خطا
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorState.error),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ),
                              );

                              // // ریست کردن استاتوس جهت جلوگیری از اجرای تکراری
                              wellDetailBloc.add(ResetCreateTimeStatus());
                            }
                          },
                          builder: (context, state) {
                            final isLoading=state.deleteTimeStatus is DeleteTimeLoading;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            if (isLoading) ...[
                              const CountdownTimerWidget(durationInSeconds: 60),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(


                                  child: RefuseButton(
                                    borderRadius: 2.5,
                                    // backColor: Colors.grey[300]!,
                                    onTap: () {
                                      wellDetailBloc.add(ResetDeleteStatus());
                                      Navigator.of(dialogContext).pop();
                                    },
                                    // widget: const Text("انصراف", style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                    flex: 2,
                                    child: GlobalElevatedButton(
                                      borderRadius: 2.5,
                                  onTap:isLoading?null: () {

                                    wellDetailBloc.add(DeleteTime(
                                        CreateTimeParams(
                                            code: wellsDataEntity.code,
                                            pin: wellsDataEntity.pin,
                                            deviceID: wellsDataEntity.deviceId,
                                            userLocalID: userLocalId,
                                            startTime: startTime,
                                            endTime: endTime,
                                            day: day


                                        )
                                    ));
                                  },widget: isLoading?
                                Center(child:CircularProgressIndicator()):
                                Text("حذف زمان",style: TextStyle(color: Colors.white),),
                                  backColor: ColorPalette.darkRed,)),
                              ],
                            ),
                          ],
                        );
                  },
                ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    //     .then((_) {
    // });
  }

  ///panel screen
  Future<void> exitShowDialog(
      BuildContext context,
      LogoutCubit logoutCubit,
      ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,

          body: BlocProvider.value(
            value: logoutCubit,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                content: SizedBox(
                  height: 60.h,
                  child: const Center(child: Text("برای تایید خروج از سیستم دکمه تایید را فشار دهید.")),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: GlobalElevatedButton(
                          borderRadius: 2.5,
                          backColor: Color(0xff5F8CC5),
                            onTap: () {
                              // Helper.saveUserLoggedInSharedPreference(false);

                              logoutCubit.logout();
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              },));
                            },
                            widget:  Text("تایید",style: TextStyle(color: Colors.black),)
                      ),),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(flex:1,child: RefuseButton(borderRadius: 2.5,))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Future<void> customDialog(
      BuildContext context,
      ) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,

          body: Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              content: SizedBox(
                height: 30.h,
                child: const Center(child: Text("شما مجاز به حذف برنامه مدیر نیستید.")),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [

                GlobalElevatedButton(
                    borderRadius: 2.5,
                    width: MediaQuery.sizeOf(context).width/3,
                    backColor: Color(0xff5F8CC5),
                    onTap: () {

                      Navigator.of(context).pop();

                    },
                    widget:  Text("باشه",style: TextStyle(color: Colors.black),)
                )
              ],
            ),
          ),
        );
      },
    );
  }


  Future<void> turnPomp(
      BuildContext context,
      WellDetailBloc wellDetailBloc,
      bool value,
      WellsDataEntity wellsDataEntity,
      ) {
    // ریست کردن استیت دیالوگ قبل از باز شدن
    wellDetailBloc.add(ResetOnOffStatus());

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        bool isPoped = false; // پرچم اطمینان از یک‌بار بسته شدن

        return BlocProvider.value(
          value: wellDetailBloc,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: BlocConsumer<WellDetailBloc, WellDetailState>(
              listenWhen: (previous, current) => previous.onOffStatus != current.onOffStatus,
              listener: (blocContext, state) {
                if (state.onOffStatus is OnOffSuccess) {
                  if (!isPoped) {
                    isPoped = true;

                    // ۱. اول استیت عملیات دیالوگ ریست می‌شود
                    wellDetailBloc.add(ResetOnOffStatus());

                    // ۲. فقط دیالوگ بسته می‌شود
                    if (Navigator.canPop(dialogContext)) {
                      Navigator.of(dialogContext).pop();
                    }
                  }
                }

                if (state.onOffStatus is OnOffError) {
                  if (!isPoped) {
                    isPoped = true;
                    final errorMsg = (state.onOffStatus as OnOffError).error;
                    wellDetailBloc.add(ResetOnOffStatus());

                    if (Navigator.canPop(dialogContext)) {
                      Navigator.of(dialogContext).pop();
                    }

                    if (context.mounted) {
                      GlobalSnackBar.show(context, message: errorMsg);
                    }
                  }
                }
              },
              builder: (blocContext, state) {
                final isLoading = state.onOffStatus is OnOffLoading;

                return AlertDialog(
                  content: Text(
                    "آیا از ${value ? "روشن" : "خاموش"} کردن پمپ مطمئن هستید؟",
                  ),
                  actions: [
                    if (isLoading) ...[
                      const CountdownTimerWidget(durationInSeconds: 60),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GlobalElevatedButton(
                            borderRadius: 2.5,
                            backColor: ColorPalette.darkBlue,
                            onTap: isLoading
                                ? null
                                : () {
                              wellDetailBloc.add(
                                SwitchClicked(
                                  value,
                                  CreateTimeParams(
                                    code: wellsDataEntity.code,
                                    pin: wellsDataEntity.pin,
                                    deviceID: wellsDataEntity.deviceId,
                                    userLocalID: wellsDataEntity.userLocalId,
                                    status: value ? 1 : 0,
                                  ),
                                  wellsDataEntity.deviceId!
                                ),

                              );
                            },
                            widget: isLoading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                                : const Text("تایید", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: GlobalElevatedButton(
                            borderRadius: 2.5,
                            backColor: Colors.grey[300]!,
                            onTap: () {
                              wellDetailBloc.add(ResetOnOffStatus());
                              if (!isPoped && Navigator.canPop(dialogContext)) {
                                isPoped = true;
                                Navigator.of(dialogContext).pop();
                              }
                            },
                            widget: const Text("انصراف", style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> alertFilter(
      BuildContext context,
      AlertBloc alertBloc,
      ) {
    alertBloc.add(AlertWellList());

    // متغیرهای موقت برای نگهداری مقادیر انتخاب شده قبل از تایید نهایی
    AlertTypeEntity? tempSelectedType = alertBloc.state.alertTypeList.isNotEmpty && alertBloc.state.selectedAlertType != null
        ? alertBloc.state.alertTypeList[alertBloc.state.selectedAlertType!]
        : null;

    AlertTypeEntity? tempSelectedStatus = alertBloc.state.alertStatusList.isNotEmpty && alertBloc.state.selectedAlertStatus != null
        ? alertBloc.state.alertStatusList[alertBloc.state.selectedAlertStatus!]
        : null;

    WellsEntity? tempSelectedWell = alertBloc.state.oneWell;
    // مقداردهی اولیه تاریخ‌ها بر اساس وضعیت واقعی فعال بودن فیلتر قبلی
    String? tempStartDate = (alertBloc.state.alertFilterModel?.filterDate == true)
        ? alertBloc.state.alertStartDate
        : null;

    String? tempEndDate = (alertBloc.state.alertFilterModel?.filterDate == true)
        ? alertBloc.state.alertEndDate
        : null;

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: BlocProvider.value(
                value: alertBloc,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("افزودن فیلتر", style: TextStyleP.f16Medium),
                          SizedBox(height: 16.h),

                          // نوع هشدار
                          Text("نوع هشدار"),
                          SizedBox(height: 6.h),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey)),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: DropdownButton<AlertTypeEntity>(
                                underline: const SizedBox(),
                                isExpanded: true,
                                padding: EdgeInsets.only(right: 15.w),
                                value: tempSelectedType,
                                items: alertBloc.state.alertTypeList
                                    .map((alertType) => DropdownMenuItem<AlertTypeEntity>(
                                  value: alertType,
                                  child: Text(alertType.name),
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setStateDialog(() {
                                    tempSelectedType = value;
                                  });
                                  alertBloc
                                      .add(OneAlertTypeClicked(value!
                                    // ,state.alertFilterModel!.copyWith(
                                    //     newFilterType: true,
                                    //     newType: value.name
                                    // )
                                  ));
                                }),
                          ),
                          SizedBox(height: 12.h),

                          // وضعیت هشدار
                          Text("وضعیت هشدار"),
                          SizedBox(height: 6.h),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey)),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: DropdownButton<AlertTypeEntity>(
                                underline: const SizedBox(),
                                isExpanded: true,
                                padding: EdgeInsets.only(right: 15.w),
                                value: tempSelectedStatus,
                                items: alertBloc.state.alertStatusList
                                    .map((alertType) => DropdownMenuItem<AlertTypeEntity>(
                                  value: alertType,
                                  child: Text(alertType.name),
                                ))
                                    .toList(),
                                onChanged: (value) {
                                  setStateDialog(() {
                                    tempSelectedStatus = value;
                                  });
                                  alertBloc
                                      .add(OneAlertStatusClicked(value!
                                  //     ,state.alertFilterModel!.copyWith(
                                  //     newFilterStatus: true,
                                  //     newStatus: value.name
                                  // )
                                  ));
                                }),
                          ),
                          SizedBox(height: 12.h),

                          // تاریخ
                          Text("تاریخ"),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: () async {
                              var picked = await showPersianDateRangePicker(
                                  context: context,
                                  firstDate: Jalali(1385, 8),
                                  lastDate: Jalali.now(),
                                  initialDate: Jalali.now(),
                                  cancelText: "انصراف"
                              );
                              String  start = picked==null?"": "${picked.start.year}/${picked.start.month.toString().padLeft(2, '0')}/${picked.start.day.toString().padLeft(2, '0')}";
                              String  end = picked==null?"": "${picked.end.year}/${picked.end.month.toString().padLeft(2, '0')}/${picked.end.day.toString().padLeft(2, '0')}";

                              if (picked != null) {

                                setStateDialog(() {
                                  tempStartDate = "${picked.start.year}/${picked.start.month.toString().padLeft(2, '0')}/${picked.start.day.toString().padLeft(2, '0')}";
                                  tempEndDate = "${picked.end.year}/${picked.end.month.toString().padLeft(2, '0')}/${picked.end.day.toString().padLeft(2, '0')}";
                                });
                                alertBloc.add(AlertChangeDate(start, end,
                                //     state.alertFilterModel!.copyWith(
                                //     newFilterDate: true,
                                //     newStartDate: start,
                                //     newEndDate: end
                                // )
                                ));

                              }
                            },
                            // در بخش نمایش تاریخ داخل دیالوگ، این کد را جایگزین کنید:
                           child:  Container(
                              width: double.infinity,
                              height: 40.h,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                               border: Border.all(color: Colors.grey),
                             ),
                             child: Center(
                                child: Text(
                                  (tempStartDate != null && tempStartDate!.isNotEmpty && tempEndDate != null && tempEndDate!.isNotEmpty)
                                      ? "$tempEndDate - $tempStartDate"
                                      : "انتخاب تاریخ",
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // چاه
                          Text("چاه"),
                          SizedBox(height: 6.h),
                          Container(
                            height: 40.h,

                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.grey),
                            ),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: BlocBuilder<AlertBloc, AlertState>(
                              builder: (context, state) {
                                if (state.alertWellListStatus is AlertWellListSuccess) {
                                  AlertWellListSuccess alertWellListSuccess = state.alertWellListStatus as AlertWellListSuccess;
                                  if (alertWellListSuccess.wellsEntity.isEmpty) {
                                    return const Center(child: Text("چاهی وجود ندارد", style: TextStyle(color: Colors.grey)));
                                  }
                                  return  DropdownButton<WellsEntity>(
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      padding: EdgeInsets.only(right: 15.w),
                                      // پیدا کردن نمونه‌ی متناظر از داخل لیست جدید بر اساس ID
                                      value: (tempSelectedWell != null)
                                          ? alertWellListSuccess.wellsEntity.firstWhereOrNull(
                                            (well) => well.data?.id == tempSelectedWell?.data?.id,
                                      )
                                          : null,
                                      items: alertWellListSuccess.wellsEntity
                                          .map((well) => DropdownMenuItem<WellsEntity>(
                                        value: well,
                                        child: Text(well.data!.wellName.toString()),
                                      ))
                                          .toList(),
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          tempSelectedWell = value;
                                        });
                                        BlocProvider.of<AlertBloc>(context).add(OneWellClicked(value!));
                                      });
                                } else if (state.alertWellListStatus is AlertWellListLoading) {
                                  return Center(child: CircularProgressIndicator());
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GlobalElevatedButton(
                                borderRadius: 2.5,
                                backColor: (tempSelectedType == null &&
                                    tempSelectedStatus == null &&
                                    tempSelectedWell == null &&
                                    tempStartDate == null)
                                    ? ColorPalette.lightGrey
                                    : ColorPalette.blue,
                                onTap: (tempSelectedType == null &&
                                    tempSelectedStatus == null &&
                                    tempSelectedWell == null &&
                                    tempStartDate == null)
                                    ? null
                                    : () {
                                  Navigator.pop(context);

                                  // اعمال نهایی فیلترها فقط پس از زدن دکمه افزودن
                                  alertBloc.add(
                                    AlertStart(
                                      filter: true,
                                      alertFilterParams: AlertFilterParams(
                                        type: tempSelectedType != null ? alertBloc.state.alertTypeList.indexOf(tempSelectedType!) : null,
                                        status: tempSelectedStatus != null ? alertBloc.state.alertStatusList.indexOf(tempSelectedStatus!) : null,
                                        wellName: tempSelectedWell?.data?.wellName,
                                        startDate: tempStartDate,
                                        endDate: tempEndDate,
                                      ),
                                    ),
                                  );

                                  // همچنین می‌توانید رویدادی برای آپدیت مدل استیت اصلی (برای نمایش چیپ‌ها) صدا بزنید:
                                  alertBloc.add(ApplyFiltersEvent(
                                    alertBloc.state.alertFilterModel!.copyWith(
                                      newFilterType: tempSelectedType != null,
                                      newType: tempSelectedType?.name,
                                      newFilterStatus: tempSelectedStatus != null,
                                      newStatus: tempSelectedStatus?.name,
                                      newFilterWellName: tempSelectedWell != null,
                                      newWellName: tempSelectedWell?.data?.wellName,
                                      newFilterDate: tempStartDate != null && tempStartDate!.isNotEmpty,
                                      newStartDate: tempStartDate,
                                      newEndDate: tempEndDate,
                                    ),
                                  ));
                                },
                                widget: Text("افزودن", style: TextStyle(color: Colors.black))),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(child: RefuseButton(borderRadius: 2.5,))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<void> sendRequestToSupport(BuildContext sendContext,
      SupportBloc supportBloc, AlertTypeEntity alertTypeEntity) {
    TextEditingController subjectController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return showDialog(
      barrierDismissible: false,
      context: sendContext,
      builder: (context) {
        final newSupportKey = GlobalKey<FormState>();

        return Scaffold(
          backgroundColor: Colors.transparent,

          body: SingleChildScrollView(
            child: BlocProvider.value(
                value: supportBloc,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    content: SizedBox(
                      height: 500.h,
                      width: 550.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("درخواست جدید به پشتیبانی"),
                          SizedBox(
                            height: 25,
                          ),
                          Form(
                              key: newSupportKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("دپارتمان مربوطه"),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    height: 35.h,
                                    width: 140.w,
                                    padding: EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(child: Text(alertTypeEntity.name)),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text("عنوان پشتیبانی"),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  TextFormField(

                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(decoration: TextDecoration.none
                                    ),


                                    decoration: InputDecoration(
                                      isDense: true,
                                      // contentPadding: EdgeInsetsGeometry.symmetric(vertical: 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),

                                      ),
                                    ),

                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "عنوان الزامی است";
                                      }
                                      return null;
                                    },
                                    controller: subjectController,
                                  ),

                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Text("شرح موضوع"),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  TextFormField(

                                    maxLines: 2,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                      return  "شرح موضوع الزامی است";
                                      }
                                      return null;
                                    },
                                    controller: descriptionController,
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 15.h,
                          ),
                          Text("پیوست فایل"),
                          SizedBox(
                            height: 5.h,
                          ),
                          BlocBuilder<SupportBloc, SupportState>(
                            // buildWhen: (previous, current) =>
                            // previous.supportFile != current.supportFile,
                            builder: (context, state) {

                              return SelectImageWidget(
                                width: 70.w,
                                height: 70.h,
                                image: state.supportFile,
                                onTap: () {
                                  BottomSheets().imageSupport(context, supportBloc);

                                },);
                            },
                          ),
                          BlocBuilder<SupportBloc, SupportState>(builder: (context, state) {
                            return Visibility(visible: state.overImage,
                                child: Text("حجم فایل بیشتر از یک مگابایت نباشد.",style: TextStyle(color: Colors.red),));
                          },),
                          SizedBox(
                            height: 25.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RefuseButton(

                                  borderRadius: 2.5,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                flex: 2,
                                child: BlocConsumer<SupportBloc, SupportState>(

                                  listenWhen: (previous, current) =>
                                  current.sendSupportStatus != previous.sendSupportStatus,
                                  listener: (context, state) {
                                    if (state.sendSupportStatus is SendSupportSuccess) {
                                      ShowSnacksBars.snack(sendContext, ConstantTexts.beRegisteredRequest,color: Colors.green,duration: 2);
                                      Navigator.of(context).pop();

                                    }
                                    if (state.sendSupportStatus is SendSupportError) {
                                      SendSupportError sendRequestError =
                                      state.sendSupportStatus
                                      as SendSupportError;
                                      ShowSnacksBars.snack(sendContext, sendRequestError.error,duration: 2);

                                      Navigator.of(context).pop();

                                    }
                                  },
                                  builder: (context, state) {
                                    return GlobalElevatedButton(
                                      borderRadius: 2.5,

                                      onTap:() async {
                                        if (newSupportKey.currentState!.validate()) {

                                          dynamic file = await ImageConverter.getMultiPart(
                                              state.supportFile,
                                              state.supportFile.split("/").last);

                                          supportBloc.add(
                                              SendNewSupportClicked(
                                                  SendNewSupportParams(
                                                      part:alertTypeEntity.id,
                                                      subject:
                                                      subjectController.text,
                                                      status: 0,
                                                      description:
                                                      descriptionController.text,
                                                      payVast: file)));
                                        }
                                      },
                                      widget: state.sendSupportStatus is SendSupportLoading?
                                      CircularProgressIndicator(): Text(
                                        "ثبت درخواست",
                                        style:  TextStyle(color: Colors.white),
                                      ),
                                      backColor: ColorPalette.darkBlue
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }

}

class CountdownTimerWidget extends StatelessWidget {
  final int durationInSeconds;

  const CountdownTimerWidget({super.key, this.durationInSeconds = 60});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
      duration: Duration(seconds: durationInSeconds),
      tween: Tween(begin: Duration(seconds: durationInSeconds), end: Duration.zero),
      builder: (BuildContext context, Duration value, Widget? child) {
        final seconds = value.inSeconds;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "شمارش معکوس تا دریافت پاسخ: ",
              style: TextStyle(fontSize: 12),
            ),
            Text(
              "${seconds.toString().toPersianDigit()} ثانیه",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                // color: Colors.blueAccent,
              ),
            ),
          ],
        );
      },
    );
  }
}

