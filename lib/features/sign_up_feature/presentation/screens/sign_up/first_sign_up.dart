import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/first_level_status.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/sign_up_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:persian_tools/persian_tools.dart';

import '../../../../../common/utils/constants.dart';
import '../../../../../common/widgets/global_elevated_button.dart';
import '../../../../../common/widgets/show_snack_bar.dart';
import '../../../../../config/texts_style.dart';


class FirstSignUp extends StatefulWidget {
  const FirstSignUp({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<FirstSignUp> createState() => _FirstSignUpState();
}

class _FirstSignUpState extends State<FirstSignUp> {
  GlobalKey<FormState> signUpFormKey = GlobalKey();

  TextEditingController nameController = TextEditingController(text: "محبوبه ولی منفرد");

  TextEditingController nationalCodeController = TextEditingController(text: "0371326915" );

  TextEditingController mobileController = TextEditingController(text: "09357912300" );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    nationalCodeController.dispose();
    mobileController.dispose();
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          Text("نام و نام خانوادگی"),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 4) {
                                return 'وارد کردن نام الزامی می باشد(حداقل ۴ حرف)';
                              }
                              if (!value.contains(" ")) {
                                return 'بین نام و نام خانوادگی باید فاصله باشد';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          Text("کد ملی"),
                          SizedBox(height: 8.h),

                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: nationalCodeController,

                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'وارد کردن کدملی الزامی می باشد';
                              }

                              if (!verifyIranianNationalId(value.toEnglishDigit())) {
                                return 'کدملی وارد شده معتبر نمی باشد';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),

                          Text("شماره تماس"),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (!Constants.validateMobile(value!)) {
                                return 'لطفا یک شماره تلفن همراه معتبر وارد کنید';
                              }
                              if (value.length < 11 || value.length > 11) {
                                return 'شماره موبایل باید ۱۱ رقم باشد';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24.h),
                          // Text("نوع ثبت نام"),
                          // SizedBox(height: 8.h),
                          // Container(
                          //   height: 55.h,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(5),
                          //     border: Border.all(color: Colors.grey),
                          //   ),
                          //   width: double.infinity,
                          //   alignment: Alignment.center,
                          //   child: BlocBuilder<ConsultantSignUpBloc, ConsultantSignUpState>(
                          //     buildWhen: (previous, current) =>
                          //     previous.teacherModel != current.teacherModel,
                          //     builder: (context, state) {
                          //       return DropdownButton<TeacherModel>(
                          //         underline: const SizedBox(),
                          //         isExpanded: true,
                          //         padding: EdgeInsets.only(right: 15.w),
                          //         value: state.teacherModel[state.selectedTeacher],
                          //         items: state.teacherModel.map(
                          //               (u) => DropdownMenuItem<TeacherModel>(
                          //             value: u,
                          //             child: Text(u.title),
                          //           ),
                          //         ).toList(),
                          //         onChanged: (value) {
                          //           BlocProvider.of<ConsultantSignUpBloc>(
                          //             context,
                          //           ).add(IsTeacherClicked(value!));
                          //         },
                          //       );
                          //     },
                          //   ),
                          // ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocConsumer<SignUpBloc, SignUpState>(
                      listener: (BuildContext context, SignUpState state) {
                        if (state.firstLevelSendStatus is FirstLevelSuccess) {
                          FirstLevelSuccess firstLevelSuccess=state.firstLevelSendStatus as FirstLevelSuccess;
                         print("firstLevelSuccess.serverId${firstLevelSuccess.serverId}");
                          BlocProvider.of<SignUpBloc>(context).add(
                            SaveServerId(
                              state.signUpParams.copyWith(
                                  newServerId:firstLevelSuccess.serverId
                              ),
                            ),
                          );
                          widget.pageController.nextPage(

                            duration: Duration(milliseconds: 5),
                            curve: Curves.bounceIn,
                          );
                        }
                        if (state.firstLevelSendStatus is FirstLevelError) {
                          FirstLevelError firstLevelStatus = state.firstLevelSendStatus as FirstLevelError;
                          ShowSnacksBars.snack(context, firstLevelStatus.error);
                        }
                      },
                      listenWhen: (previous, current) =>
                      previous.firstLevelSendStatus != current.firstLevelSendStatus,
                      builder: (context, state) {
                        return GlobalElevatedButton(
                          width: double.infinity,
                          backColor: ColorPalette.darkBlue,
                          onTap: () async {
                            if (signUpFormKey.currentState!.validate()) {

                                BlocProvider.of<SignUpBloc>(context).add(
                                    FirstSignUpButtonClicked(
                                      state.signUpParams.copyWith(
                                        newName: nameController.text,
                                        newMobile: mobileController.text
                                            .toEnglishDigit(),
                                        newNationalCode: nationalCodeController.text,
                                        newStep: state.step!+1
                                      ),
                                    ),
                                  );

                            }
                          },
                          widget: state.firstLevelSendStatus is FirstLevelLoading
                              ? const CircularProgressIndicator()
                              : Text("ارسال کد تایید", style: TextStyleP.colorBlack),
                        );
                      },
                    ),
                  ],
                ),
              )
          ),
        );
      },));
  }
}
