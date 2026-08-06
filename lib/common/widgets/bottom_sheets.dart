import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/support_feature/presentation/bloc/support_bloc.dart';
import 'global_elevated_button.dart';

class BottomSheets {

  Future<void> _showSettingsPrompt(BuildContext context, String permissionName) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'دسترسی $permissionName رد شده است',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10),
              const Text(
                'لطفاً برای استفاده از این قابلیت، به تنظیمات بروید و مجوزهای لازم را فعال کنید.',
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(bc); // بستن باتم شیت
                    },
                    child: const Text('انصراف',style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 10),
                  GlobalElevatedButton(
                    backColor: ColorPalette.darkBlue,

                    onTap: () {
                      Navigator.pop(bc); // بستن باتم شیت
                      openAppSettings(); // رفتن به تنظیمات
                    },
                    widget: const Text('رفتن به تنظیمات',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
// ----------------------------------------------------
// متدهای کمکی برای مدیریت مجوزها
// ----------------------------------------------------

// بررسی و درخواست مجوز برای یک منبع خاص
// متد اصلاح شده برای بررسی و درخواست مجوز
  Future<bool> _checkAndRequestPermission(BuildContext context, ImageSource source) async {
    PermissionStatus status;
    String permissionName;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
      permissionName = 'دوربین';
    } else {
      permissionName = 'گالری';

      // مدیریت درست دسترسی گالری بر اساس نسخه اندروید
      if (Platform.isAndroid) {
        // در اندروید ۱۳ به بالا photo/media استفاده می‌شود
        status = await Permission.photos.request();

        // اگر photos پشتیبانی نشد (اندروید ۱۲ و پایین‌تر)، storage را چک کن
        if (status.isDenied) {
          status = await Permission.storage.request();
        }
      } else {
        // برای iOS
        status = await Permission.photos.request();
      }
    }

    // ۱. اگر دسترسی داده شده باشد
    if (status.isGranted || status.isLimited) {
      return true;
    }

    // ۲. اگر کاربر برای همیشه رد کرده باشد (Permanently Denied)
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsPrompt(context, permissionName);
      }
      return false;
    }

    // ۳. اگر دفعه اول/دوم رد کرده باشد (Denied)
    if (status.isDenied) {
      // می‌توانید مجدداً درخواست دهید یا پیغام مناسب دهید
      return false;
    }

    return false;
  }
  // Future<void> settingNewPlanBottomSheet(
  //     BuildContext context,
  //     PlanBloc planBloc,
  //     String todayDate,
  //     String weekToday,
  //     List<MonthlyOtherEntity> monthlyOtherEntity,
  //     ) {
  //   print(monthlyOtherEntity);
  //
  //   return showModalBottomSheet(
  //     useSafeArea: true,
  //     scrollControlDisabledMaxHeightRatio: 0.8,
  //
  //     context: context,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(15),
  //         topRight: Radius.circular(15),
  //       ),
  //     ),
  //     builder: (cContext) {
  //       return BlocProvider.value(
  //         value: planBloc,
  //         child: Container(
  //           constraints: BoxConstraints(maxHeight: double.infinity),
  //
  //           padding: const EdgeInsets.all(20),
  //
  //           width: MediaQuery.sizeOf(context).width,
  //           decoration: const BoxDecoration(color: Colors.white),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   Text(weekToday),
  //                   const SizedBox(width: 10),
  //                   Text(todayDate, style: TextStyle(color: Colors.black)),
  //                 ],
  //               ),
  //               SizedBox(height: 19.h),
  //
  //               const Text("نوع مشاوره"),
  //               const SizedBox(height: 8),
  //               BlocBuilder<PlanBloc, PlanState>(
  //                 buildWhen: (previous, current) =>
  //                 previous.selectedCallType != current.selectedCallType,
  //                 builder: (context, state) {
  //                   return Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 5),
  //                     decoration: BoxDecoration(
  //                       border: Border.all(),
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     width: 150.w,
  //                     height: 30.h,
  //                     alignment: Alignment.center,
  //                     child: DropdownButton<CallTypeEntity>(
  //                       padding: const EdgeInsets.only(right: 15),
  //                       underline: const SizedBox(),
  //                       isExpanded: true,
  //                       value:
  //                       state.callTypeEntity![state.selectedCallType! - 1],
  //                       items: state.callTypeEntity!
  //                           .map(
  //                             (callType) => DropdownMenuItem<CallTypeEntity>(
  //                           value: callType,
  //                           child: Text(callType.type),
  //                         ),
  //                       )
  //                           .toList(),
  //                       onChanged: (value) {
  //                         planBloc.add(CallTypeChoosed(value!));
  //                       },
  //                     ),
  //                   );
  //                 },
  //               ),
  //                SizedBox(height: 19.h),
  //               const Text("زمان شروع مشاوره (حداکثر ۲۳:۱۵)"),
  //                SizedBox(height: 8),
  //               CustomTimePicker(
  //
  //                 monthlyOtherEntity: monthlyOtherEntity,
  //                 // اینجا مقادیر ساعت و دقیقه به Bloc ارسال می‌شود
  //                 onTimeSelected: (hour, minute, endHour,endMinute,conflict) {
  //                   planBloc.add(TimeSelected(hour, minute, endHour,endMinute,conflict));
  //                 },
  //               ),
  //                SizedBox(height: 5.h),
  //
  //               BlocBuilder<PlanBloc, PlanState>(
  //                 buildWhen: (previous, current) => previous.conflict!=current.conflict,
  //                 builder: (context, state) {
  //                   return Visibility(
  //                   visible: !state.conflict,
  //                   child: Text("تداخل زمانی با ساعت های قبلی با محاسبه ۵ دقیقه استراحت",style: TextStyle(color: Colors.red),));
  //                 },
  //               ),
  //
  //               SizedBox(height: 19.h),
  //
  //               const Text("پیامک یادآوری شروع جلسه"),
  //               const SizedBox(height: 8),
  //               // SegmentedButton(segments:<ButtonSegment<dynamic>> [
  //               //   ButtonSegment<dynamic>(value: "5 دقیقه",label: Text("5 دقیقه")),
  //               //   ButtonSegment<dynamic>(value: "10 دقیقه",label: Text("10 دقیقه")),
  //               //   ButtonSegment<dynamic>(value: "15 دقیقه",label: Text("15 دقیقه")),
  //               //
  //               // ], selected: {"5 دقیقه"}),
  //               BlocBuilder<PlanBloc, PlanState>(
  //                 buildWhen: (previous, current) => previous.rememberTime != current.rememberTime,
  //
  //                 builder: (context, state) {
  //                   return Container(
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: Color(0xffE7E7E7)),
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     height: 40.h,
  //                     width: MediaQuery.sizeOf(context).width,
  //                     child: Row(
  //                       children: List.generate(3, (index) {
  //                         return Expanded(
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               planBloc.add(RememberTimeChoosed(index + 1));
  //                             },
  //                             child: Container(
  //
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(5),
  //                                 color: index + 1 == state.rememberTime
  //                                     ? Color(0xffE7E7E7)
  //                                     : Colors.transparent,
  //                               ),
  //                               child: Center(
  //                                 child: Text("${((index + 1) * 5).toString().toPersianDigit()} دقیقه قبل",
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                     ),
  //                   );
  //                 },
  //               ),
  //
  //               SizedBox(height: 30.h),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   GlobalElevatedButton(
  //                     widget: const Text(
  //                       "انصراف",
  //                       style: TextStyle(color: Colors.black),
  //                     ),
  //                     backColor: Color(0xffEBEBEB),
  //                     width: 150.w,
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //
  //                   BlocConsumer<PlanBloc, PlanState>(
  //                     listenWhen: (previous, current) =>previous.consultationRegistrationStatus != current.consultationRegistrationStatus,
  //                     listener: (context, state)  {
  //
  //                       if (state.consultationRegistrationStatus is ConsultationRegistrationSuccess) {
  //                         Navigator.of(context).pop();
  //
  //                         ShowSnacksBars.snack(context, "ثبت شد", color: Colors.green,duration: 3);
  //                         planBloc.add(SelectOneDate(todayDate.toEnglishDigit()),);
  //                       }
  //                       if (state.consultationRegistrationStatus is ConsultationRegistrationError) {
  //                         ConsultationRegistrationError consultationRegistrationError = state.consultationRegistrationStatus as ConsultationRegistrationError;
  //                         Navigator.of(context).pop();
  //                         ShowSnacksBars.snack(context, consultationRegistrationError.error,
  //                         );
  //                       }
  //
  //                     },
  //                     builder: (context, state) {
  //                       if (state.consultationRegistrationStatus is ConsultationRegistrationLoading) {
  //                         return const Center(child: CircularProgressIndicator(),
  //                         );
  //                       } else {
  //                         return GlobalElevatedButton(
  //                           width: 150.w,
  //                           widget:state.consultationRegistrationStatus is ConsultationRegistrationLoading?
  //                           CircularProgressIndicator():
  //                           const Text("ثبت برنامه جدید",
  //                             style: TextStyle(color: Colors.white),
  //                           ),
  //                           backColor: Colors.green,
  //                           onTap:state.conflict? () async{
  //                             if(state.selectedHour=="00" || state.selectedMinute=="00"){
  //                                  ShowSnacksBars.snack(context, "بازه انتخابی شما از نیمه شب گذشته است",duration: 3,color: Colors.green);
  //
  //                                }else{
  //                                  planBloc.add(
  //                                      ConsultationRegistrationClicked(
  //                                          ConsultationRegistrationParams(
  //                                            date: todayDate.toEnglishDigit(),
  //                                            type:
  //                                            state.selectedCallType ,
  //                                            remember: state.rememberTime,
  //                                            duration: 45,
  //                                            clock1: "${state.selectedHour}:${state.selectedMinute}",
  //                                            clock2: "${state.endHour}:${state.endMinute}",
  //                                          )));
  //                                }
  //
  //                           }:null,
  //                         );
  //                       }
  //                     },
  //                   ),
  //
  //                 ],
  //               ),
  //             ],
  //           ),
  //         )
  //       );
  //     },
  //   );
  // }



  Future<void> imageSupport(BuildContext context, SupportBloc supportBloc) async {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: supportBloc,
          child: SizedBox(
            height: 70.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //  دکمه دوربین
                GlobalElevatedButton(
                  widget: const Text("دوربین", style: TextStyle(color: Colors.black)),
                  onTap: () async {
                    final cameraGranted = await _checkAndRequestPermission(context, ImageSource.camera);

                    if (context.mounted) {
                      if (cameraGranted) {
                        supportBloc.add(AddSupportImageClicked());
                        Navigator.of(context).pop();
                      } else {
                        // ShowSnacksBars.snack(
                        //   context,
                        //   "برای گرفتن عکس، به دسترسی دوربین نیاز است.",
                        //   duration: 3,
                        // );
                      }
                    }
                  },
                ),

                //  دکمه گالری
                GlobalElevatedButton(
                  widget: const Text("گالری", style: TextStyle(color: Colors.black)),
                  onTap: () async {
                    final galleryGranted = await _checkAndRequestPermission(context, ImageSource.gallery);

                    if (context.mounted) {
                      if (galleryGranted) {
                        supportBloc.add(AddSupportFileClicked());
                        Navigator.of(context).pop();
                      } else {
                        // ShowSnacksBars.snack(
                        //   context,
                        //   "برای انتخاب فایل، به دسترسی گالری نیاز است.",
                        //   duration: 3,
                        // );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Future<void> imageResume(BuildContext context,ResumeBloc resumeBloc) {
  //
  //   return  showModalBottomSheet(context: context, builder: (context) {
  //     return BlocProvider.value(
  //       value: resumeBloc,
  //       child: SizedBox(
  //         height: 70.h,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             GlobalElevatedButton(widget: Text("دوربین",style: TextStyle(color: Colors.black)),onTap: () async {
  //               final cameraGranted = await _checkAndRequestPermission(context, ImageSource.camera);
  //               if (cameraGranted ) {
  //               resumeBloc.add( ResumeImagePicked());
  //               Navigator.of(context).pop();
  //
  //               }
  //               else{
  //                 Navigator.of(context).pop();
  //
  //               ShowSnacksBars.snack(context, "دسترسی به دوربین یا گالری برای انتخاب عکس مورد نیاز است.",duration: 4);
  //               }
  //             }),
  //             GlobalElevatedButton(widget: Text("گالری",style: TextStyle(color: Colors.black)),onTap: ()  {
  //
  //               resumeBloc.add( ResumeFilePicked());
  //               Navigator.of(context).pop();
  //
  //             },),
  //           ],
  //         ),
  //       ),
  //     );
  //   },);
  //
  // }
  //
  // Future<void> imageDetailSupport(BuildContext context,SupportDetailBloc supportDetailBloc) async {
  //
  //   return  showModalBottomSheet(context: context, builder: (context) {
  //     return BlocProvider.value(
  //       value: supportDetailBloc,
  //       child: SizedBox(
  //         height: 70.h,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             GlobalElevatedButton(widget: Text("دوربین",style: TextStyle(color: Colors.black)),onTap: () async {
  //
  //               final cameraGranted = await _checkAndRequestPermission(context, ImageSource.camera);
  //
  //               if (cameraGranted ) {
  //                 Navigator.of(context).pop();
  //
  //                 supportDetailBloc.add( AddSupportDetailImageClicked());
  //               }
  //         else{
  //
  //           ShowSnacksBars.snack(context, "دسترسی به دوربین یا گالری برای انتخاب عکس مورد نیاز است.",duration: 4);
  //           Navigator.of(context).pop();
  //
  //               }
  //             },),
  //             GlobalElevatedButton(widget: Text("گالری",style: TextStyle(color: Colors.black)),onTap: () {
  //
  //                 supportDetailBloc.add(const AddSupportDetailFileClicked());
  //                 Navigator.of(context).pop();
  //
  //
  //             },),
  //           ],
  //         ),
  //       ),
  //     );
  //   },);
  //
  // }
  // Future<void> imageDetailMessage(BuildContext context,MessageDetailBloc messageDetailBloc) async {
  //
  //   return  showModalBottomSheet(context: context, builder: (context) {
  //     return BlocProvider.value(
  //       value: messageDetailBloc,
  //       child: SizedBox(
  //         height: 70.h,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             GlobalElevatedButton(widget: Text("دوربین",style: TextStyle(color: Colors.black)),onTap: () async {
  //
  //         final cameraGranted = await _checkAndRequestPermission(context, ImageSource.camera);
  //
  //         if (cameraGranted ) {
  //           messageDetailBloc.add( AddMessageImageClicked());
  //           Navigator.of(context).pop();
  //
  //         }
  //         else{
  //
  //           ShowSnacksBars.snack(context, "دسترسی به دوربین یا گالری برای انتخاب عکس مورد نیاز است.",duration: 4);
  //           Navigator.of(context).pop();
  //
  //         }
  //
  //             },),
  //             GlobalElevatedButton(widget: Text("گالری",style: TextStyle(color: Colors.black)),onTap: () {
  //
  //                 messageDetailBloc.add(const AddDetailFileClicked());
  //                 Navigator.of(context).pop();
  //
  //
  //
  //             },),
  //           ],
  //         ),
  //       ),
  //     );
  //   },);
  //
  // }


}











