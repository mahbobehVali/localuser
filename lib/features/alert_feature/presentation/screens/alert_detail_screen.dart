import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/send_new_request_to_support_params.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/common/widgets/global_snackbar.dart';
import 'package:mahaliii/common/widgets/icon_container.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_data_entity.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_create_usecase.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_detail_usecase.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_usecase.dart';
import 'package:mahaliii/features/alert_feature/presentation/bloc/alert_bloc.dart';
import 'package:mahaliii/features/alert_feature/presentation/bloc/alert_create_status.dart';
import 'package:mahaliii/features/alert_feature/presentation/bloc/alert_detail_status.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/area_usecase.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/region_usecase.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/wells_list_usecase.dart';
import 'package:mahaliii/locator.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class AlertDetailScreen extends StatelessWidget {
   AlertDetailScreen({super.key,required this.alertDataEntity});
  final AlertDataEntity alertDataEntity;
  final TextEditingController createController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AlertBloc>(
      create: (context) {
        AlertBloc alertBloc=AlertBloc(
          locator<AlertUseCase>(),
          locator<RegionUseCase>(),
          locator<AreaUseCase>(),
          locator<WellsListUseCase>(),
          locator<AlertDetailUseCase>(),
          locator<AlertCreateUseCase>(),
        );
        alertBloc.add(AlertDetailEvent(alertDataEntity.id!,alertDataEntity.status!));
        return alertBloc;
      },
  child: Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text( "اطلاعات کامل هشدار ارسال شده",style: TextStyleP.f16Medium,),
                  IconButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                      ),

                    ),
                    icon:  Icon(Icons.cancel_presentation_outlined,size: 30.sp),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconContainer(
                            icon: Icon(Icons.error_outline,size: 25.sp,),
                            color: ColorPalette.lightGrey,
                          ),
                          SizedBox(width: 5.w),
                          Text(alertDataEntity.message!),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: alertDataEntity.status==0 ?ColorPalette.lightBlue:
                          alertDataEntity.status==1?ColorPalette.analysingColor:
                          ColorPalette.solvedColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          alertDataEntity.status == 0
                              ? "جدید"
                              : alertDataEntity.status == 1
                              ? "در حال بررسی"
                              : "رفع شده",
                        style: TextStyle(color: alertDataEntity.status==0 ?ColorPalette.newTextColor:
                        alertDataEntity.status==1?ColorPalette.analysingTextColor:
                            ColorPalette.solvedTextColor)),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.w),

                  Padding(
                    padding: EdgeInsets.only(right: 12.w,bottom: 32.h),
                    child: IntrinsicHeight( // <--- حل مشکل نمایش ندادن VerticalDivider
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          VerticalDivider(
                            color: ColorPalette.grey,
                            width: 2,
                            thickness: 1,
                          ),
                          SizedBox(width: 8.h),

                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: ColorPalette.lightGrey.withValues(alpha: 0.3),
                                    border: BoxBorder.all(
                                      color: ColorPalette.lightGrey.withValues(alpha: 0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            alertDataEntity.clock!
                                                .toString()
                                                .toPersianDigit(),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                alertDataEntity.date!
                                                    .toString()
                                                    .toPersianDigit(),
                                              ),
                                              SizedBox(width: 4.w),
                                              Icon(
                                                Icons.calendar_month_outlined,
                                                color: ColorPalette.mediumGrey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 17.h),
                                      Text(alertDataEntity.message!),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(top: 12),
                                  decoration: BoxDecoration(
                                    color: ColorPalette.lightGrey.withValues(alpha: 0.3),
                                    border: BoxBorder.all(
                                      color: ColorPalette.lightGrey.withValues(alpha: 0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "وضعیت هشدار",
                                        style: TextStyleP.f14Bold,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "لطفا وضعیت هشدار را در هر مرحله کار مشخص کنید و همراه آن توضیحی ارسال فرمایید.",
                                      ),
                                      SizedBox(height: 8.h),
                                      BlocBuilder<AlertBloc,AlertState>(builder: (context, state) {
                                        return Row(
                                            children: List.generate(2, (index) {
                                              Color color=index==0? ColorPalette.orange:ColorPalette.darkGreen;
                                              return Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BlocProvider.of<AlertBloc>(context).add(ChangeAlert(Constants().alertCrete[index]["status"]));
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    margin: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      // color: ColorPalette.darkBlue,
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: BoxBorder.all(color:color)
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Icon(Constants().alertCrete[index]["status"]==state.alert?
                                                        Icons.circle:
                                                        Icons.circle_outlined,color: color,size: 14.sp),
                                                        Text(Constants().alertCrete[index]["title"],
                                                          style: TextStyle(color: color),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },)
                                        );
                                      },),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(child: BlocBuilder<AlertBloc, AlertState>(
                  builder: (context, state) {
                    if(state.alertDetailStatus is AlertDetailLoading){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(state.alertDetailStatus is AlertDetailError){
                      AlertDetailError alertDetailError=state.alertDetailStatus as AlertDetailError;

                      return Center(child: Text(alertDetailError.error));
                    }else if(state.alertDetailStatus is AlertDetailEmpty){
                      return Center(child: Text("پاسخی وجود ندارد"));
                    }if(state.alertDetailStatus is AlertDetailSuccess){
                      AlertDetailSuccess alertDetailSuccess =state.alertDetailStatus as AlertDetailSuccess;

                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: alertDetailSuccess.alertDetailEntity.length,
                        itemBuilder: (context, index) {
                          final item = alertDetailSuccess.alertDetailEntity[index];

                          return IntrinsicHeight( // ۱. این ویجت باعث هم‌ارتفاع شدن ستون‌های چپ و راست می‌شود
                            child: Padding(
                              padding:  EdgeInsets.only(bottom: 8.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  Row(
                                    children: [
                                      IconContainer(
                                        width: 25.sp,
                                        icon: Image.asset("assets/icons/user.png"),
                                        color: ColorPalette.lightGrey,
                                      ),
                                      SizedBox(width: 8.h),

                                      Text(item.userName ?? ''),

                                    ],
                                  ),


                                  SizedBox(height: 12.w),

                                  Expanded( // ۴. جلوگیری از خطای Overflow در محتوای متنی
                                    child: Padding(padding: EdgeInsets.only(right:12.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        VerticalDivider(
                                          color: ColorPalette.grey,
                                          width: 2,
                                          thickness: 1,
                                        ),
                                        SizedBox(width: 8.h),

                                        Expanded(child: Container(
                                          padding: const EdgeInsets.all(12),

                                          decoration: BoxDecoration(
                                            color: ColorPalette.lightGrey.withValues(alpha: 0.3),
                                            borderRadius: BorderRadius.circular(5),
                                            border: BoxBorder.all(color: ColorPalette.lightGrey.withValues(alpha: 0.5))
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(item.clock!.toString().toPersianDigit()),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Text(item.date!.toString().toPersianDigit()),
                                                      SizedBox(width: 4.w),
                                                      Icon(
                                                        Icons.calendar_month_outlined,
                                                        color: ColorPalette.mediumGrey,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 17.h),
                                              Text(item.message ?? ''),
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }else{
                      return SizedBox();
                    }

                  }

                )),
              BlocConsumer<AlertBloc, AlertState>(
                listenWhen: (previous, current) => previous.alertCreateStatus!=current.alertCreateStatus,

                listener: (context, state) {
                   if(state.alertCreateStatus is AlertCreateSuccess){
                     GlobalSnackBar.show(context, message: "ارسال شد");
                   }
                   if(state.alertCreateStatus is AlertCreateError){
                     GlobalSnackBar.show(context, message: "خطایی رخ داده");
                   }

                 },
                  builder: (context, state) {
                    return Row(
                children: [
                  Expanded(child: SizedBox(
                    height: 40.h,
                    child: TextFormField(
                      controller:createController ,
                      maxLines: 2,
                      decoration: InputDecoration(
                        suffixIcon: SizedBox(
                          width: 90.w,
                          height: double.infinity,
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: createController,
                            builder: (context, value, child) {
                              return GlobalElevatedButton(widget:
                              state.alertCreateStatus is AlertCreateLoading
                                  ?
                              Center(child: CircularProgressIndicator(),)
                                  : Text(
                                "ارسال",
                                style: TextStyle(color: ColorPalette.white),),
                                backColor: ColorPalette.darkBlue,
                                onTap:
                                createController.text.isEmpty ||
                                    state.alert ==  null?(){
                                      GlobalSnackBar.show(context, message: "متن پیام و وضعیت هشدار را مشخص کنید");

                                    }  :
                                    () {
                                      print("sffdf");
                                      BlocProvider.of<AlertBloc>(context).add(
                                          AlertCreateEvent(SendNewSupportParams(
                                              status: state.alert,
                                              description: createController.text,
                                            id: alertDataEntity.id
                                          )));
                                    }

                              );

                            }
                          ),
                        )
                      ),

                    ),
                  )),

                ],
              );
            },
          )

            ],
          ),
        ),
      ),
    ),
);
  }
}
