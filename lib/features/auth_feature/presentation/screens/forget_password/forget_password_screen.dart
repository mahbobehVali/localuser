import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/forget_password_params.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/features/auth_feature/domain/usecase/get_code_usecase.dart';
import 'package:mahaliii/features/auth_feature/presentation/bloc/login_bloc/forget_reset_status.dart';
import 'package:mahaliii/features/auth_feature/presentation/screens/login_screen.dart';

import '../../../../../common/utils/constant_texts.dart';
import '../../../../../common/utils/constants.dart';
import '../../../../../common/widgets/global_elevated_button.dart';
import '../../../../../common/widgets/show_snack_bar.dart';
import '../../../../../config/texts_style.dart';
import '../../../../../locator.dart';
import '../../../domain/usecase/forget_pass_usecase.dart';
import '../../../domain/usecase/login_usecase.dart';
import '../../bloc/login_bloc/login_bloc.dart';

class ForgetPasswordScreen extends StatefulWidget {

  const ForgetPasswordScreen(
      {super.key,required this.serverId,required this.mobile});

  final int serverId;
  final String mobile;

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  GlobalKey<FormState> forgetKey = GlobalKey();

  TextEditingController passController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passController.dispose();
    codeController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: BlocProvider<LoginBloc>(
        create: (context) {
          return LoginBloc(
            locator<LoginUseCase>(),
            locator<GetCodeUseCase>(),
            locator<ForgetPassUseCase>(),
          );
        },
        child: Padding(
          padding:  EdgeInsets.only(left: 15,right: 15,top: 50.h),
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child:  ConstrainedBox(
                constraints: BoxConstraints(
                  // تعیین حداقل ارتفاع محتوا به اندازه ارتفاع موجود در صفحه
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("فراموشی رمز عبور",style: TextStyleP.f14Bold.copyWith(color: ColorPalette.primaryTextGreen),),
                      SizedBox(height: 64.h),

                      Text("رمز عبور جدید خود را وارد کنید.",style: TextStyleP.f16Medium,),
                      SizedBox(height: 40.h),
                      Form(
                        key: forgetKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("کد اعتبارسنجی"),
                            SizedBox(height: 8.h),
                            TextFormField(

                              controller: codeController,
                              keyboardType: TextInputType.number,
                              validator: (value) {

                                if (value!.length < 4) {
                                  return 'شماره موبایل باید 11 رقم باشد';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.h),
                            RichText(
                              text: TextSpan(
                                text: 'رمز عبور جدید\n',
                                style: DefaultTextStyle.of(context).style,
                                children: const <TextSpan>[
                                  TextSpan(text: '(طول رمز عبور حداقل ۱۰ کاراکتر، ترکیبی از عدد، حروف انگلیسی و کاراکتر خاص)', style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),

                            TextFormField(

                              controller: passController,
                              // obscureText: true,
                              validator: (value) {
                                if (value!.length < 10 || value.isEmpty || !Constants.isPasswordValid(value)) {
                                  return "رمز عبور معتبر نیست";
                                }
                                return null;
                              },
                            )
                          ],
                        ),
                      ),


                      SizedBox(height: 8.h),

                      BlocConsumer<LoginBloc, LoginState>(
                        listenWhen: (previous, current) => current.forgetPasswordStatus != previous.forgetPasswordStatus,
                        buildWhen: (previous, current) => current.forgetPasswordStatus != previous.forgetPasswordStatus,
                        builder: (context, state) {
                          return GlobalElevatedButton(
                            width: double.infinity,
                            onTap: () {
                              if (forgetKey.currentState!.validate()) {
                                BlocProvider.of<LoginBloc>(context).add(
                                  ForgetPassword(
                                    ForgetPasswordParams(
                                      mobile: widget.mobile,
                                      code: int.parse(codeController.text),
                                      password: passController.text,
                                      serverId: widget.serverId
                                    )
                                  )
                                );
                              }
                            },
                            widget: (state.forgetPasswordStatus is ForgetPasswordLoading)
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(ConstantTexts.entrance,style: TextStyle(color: Colors.black),),
                            backColor: ColorPalette.darkBlue,
                          );
                        },
                        listener: (BuildContext buildContext, LoginState state) {
                          if (state.forgetPasswordStatus is ForgetPasswordSuccess) {

                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            },),(route) => false);
                          }
                          if (state.forgetPasswordStatus is ForgetPasswordError) {
                            ForgetPasswordError authError = state.forgetPasswordStatus as ForgetPasswordError;
                            ShowSnacksBars.snack(context, authError.error);
                          }
                        },
                      ),

                    ],
                  ),
                ),
              ),
            );
          },),
        ),
      ),
    );
  }
}
