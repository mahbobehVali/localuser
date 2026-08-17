import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/sign_up_params.dart';
import 'package:mahaliii/common/widgets/refuse_button.dart';
import 'package:mahaliii/features/sign_up_feature/domain/entity/area_entity.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/region_status.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/register_status.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../common/widgets/global_elevated_button.dart';
import '../../../../../common/widgets/show_snack_bar.dart';
import '../../../../../config/color_palette.dart';
import '../../../../../config/texts_style.dart';
import '../../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../../../../auth_feature/presentation/screens/login_screen.dart';
import '../../../domain/entity/region_entity.dart';
import '../../bloc/again_validation_status.dart';
import '../../bloc/area_status.dart';
import '../../bloc/sign_up_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  GlobalKey<FormState> signUpFormKey = GlobalKey();

  TextEditingController passController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    codeController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(automaticallyImplyLeading: false),
          body: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child:ConstrainedBox(
                  constraints: BoxConstraints(
                    // تعیین حداقل ارتفاع محتوا به اندازه ارتفاع موجود در صفحه
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Text(
                          "لطفا اطلاعات خواسته شده را به صورت کامل وارد کنید.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30.h),

                        Form(
                          key: signUpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("نوع مسئولیت"),
                              SizedBox(height: 8.h),
                              BlocBuilder<SignUpBloc, SignUpState>(
                                // buildWhen: (previous, current) =>
                                // current.selectedAlertType!=previous.selectedAlertType,

                                builder: (context, state) {

                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.grey)),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child:
                                    DropdownButton<AlertTypeEntity>(
                                        underline: const SizedBox(),
                                        isExpanded: true,
                                        padding: EdgeInsets.only(right: 15.w),
                                        value: state.responsibilityList[state.selectedResponsibility!],
                                        items: state.responsibilityList
                                            .map((alertType) =>
                                            DropdownMenuItem<AlertTypeEntity>(
                                              value: alertType,
                                              child: Text(alertType.name),
                                            ))
                                            .toList(),
                                        onChanged: (value) {
                                          BlocProvider.of<SignUpBloc>(context)
                                              .add(ResponsibilityChanged(value!));
                                        }),
                                  );
                                },
                              ),
                              SizedBox(height: 10.h),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("انتخاب منطقه"),
                                        SizedBox(height: 8.h),
                                        Container(
                                          height: 50.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: BlocBuilder<SignUpBloc, SignUpState>(
                                            builder: (context, state) {
                                              if(state.regionStatus is RegionSuccess){
                                                RegionSuccess regionSuccess=state.regionStatus as RegionSuccess;
                                                var regionIndex = 0;
                                                if (state.oneRegionEntity != null) {
                                                  regionIndex = regionSuccess.regionEntity.indexWhere(
                                                          (element) => element.id == state.oneRegionEntity!.id);
                                                }
                                                return DropdownButton<RegionEntity>(
                                                    underline: const SizedBox(),
                                                    isExpanded: true,
                                                    padding: EdgeInsets.only(right: 15.w),
                                                    value: regionSuccess.regionEntity[regionIndex],

                                                    items: regionSuccess.regionEntity
                                                        .map((region) =>
                                                        DropdownMenuItem<RegionEntity>(
                                                          value: region,
                                                          child:
                                                          Text(region.name!.toString()),
                                                        ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      BlocProvider.of<SignUpBloc>(context)
                                                          .add(OneRegionClicked(value!));
                                                    });

                                              }else if (state.regionStatus is RegionLoading){
                                                return Center(child: CircularProgressIndicator(),);
                                              }else if (state.regionStatus is RegionError){
                                                RegionError regionError=state.regionStatus as RegionError;
                                                return Center(child: Text(regionError.error));
                                              }else {
                                                return SizedBox();
                                              }
                                            },
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10.w,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [

                                        Text("انتخاب ناحیه"),
                                        SizedBox(height: 8.h),
                                        Container(
                                          height: 50.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: Colors.grey),
                                          ),
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: BlocBuilder<SignUpBloc, SignUpState>(
                                            builder: (context, state) {
                                              if(state.areaStatus is AreaSuccess){
                                                AreaSuccess areaSuccess=state.areaStatus as AreaSuccess;
                                                var areaIndex = 0;
                                                if (state.oneAreaEntity != null) {
                                                  areaIndex = areaSuccess.areaEntity.indexWhere(
                                                          (element) => element.id == state.oneAreaEntity!.id);
                                                }
                                                return DropdownButton<AreaEntity>(
                                                    underline: const SizedBox(),
                                                    isExpanded: true,
                                                    padding: EdgeInsets.only(right: 15.w),
                                                    value: areaSuccess.areaEntity[areaIndex],

                                                    items:  areaSuccess.areaEntity
                                                        .map((area) =>
                                                        DropdownMenuItem<AreaEntity>(
                                                          value: area,
                                                          child:
                                                          Text(area.name!.toString()),
                                                        ))
                                                        .toList(),
                                                    onChanged: (value) {
                                                      BlocProvider.of<SignUpBloc>(context)
                                                          .add(OneAreaClicked(value!));
                                                    });
                                              }else if (state.areaStatus is AreaLoading){
                                                return Center(child: CircularProgressIndicator(),);
                                              }else if (state.areaStatus is AreaError){
                                                AreaError areaError=state.areaStatus as AreaError;
                                                return Center(child: Text(areaError.error));
                                              }else {
                                                return SizedBox();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(height: 8.h),

                              Text("رمز عبور"),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: passController,
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              BlocConsumer<SignUpBloc, SignUpState>(
                                listener: (BuildContext context, SignUpState state) {
                                  if (state.registerStatus is RegisterComplete) {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    },), (route) => false);
                                  }
                                  if (state.registerStatus is RegisterError) {
                                    RegisterError registerError = state.registerStatus as RegisterError;
                                    ShowSnacksBars.snack(context, registerError.error);
                                  }
                                },

                                builder: (context, state) {
                                  return GlobalElevatedButton(
                                    width: double.infinity,
                                    backColor: ColorPalette.darkBlue,
                                    onTap: () async {
                                      if (signUpFormKey.currentState!.validate()) {

                                        BlocProvider.of<SignUpBloc>(context).add(
                                          RegisterClicked(
                                            SignUpParams(
                                              password: passController.text,
                                              areaId: state.oneAreaEntity!.id,
                                              type: state.selectedResponsibility,
                                              mobile: state.signUpParams.mobile,
                                              serverId: state.signUpParams.serverId,
                                              nationalCode: state.signUpParams.nationalCode,
                                              name: state.signUpParams.name,
                                              code: state.signUpParams.code,
                                            )
                                          ),
                                        );
                                      }
                                    },
                                    widget: state.registerStatus is RegisterLoading
                                        ? const CircularProgressIndicator()
                                        : Text("تکمیل ثبت نام", style: TextStyleP.colorBlack),
                                  );
                                },
                              ),
                              RefuseButton(
                                width: double.infinity,
                                onTap: () {
                                widget.pageController.previousPage(

                                  duration: Duration(milliseconds: 5),
                                  curve: Curves.bounceIn,
                                );
                              },)

                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            );
          },));
  }
}
