import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/features/auth_feature/domain/usecase/forget_pass_usecase.dart';
import 'package:mahaliii/features/auth_feature/domain/usecase/get_code_usecase.dart';
import 'package:mahaliii/features/auth_feature/presentation/screens/forget_password/enter_mobile_screen.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/screens/sign_up/sign_up_screen.dart';

import '../../../../common/params/login_params.dart';
import '../../../../common/utils/constant_texts.dart';
import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/global_elevated_button.dart';
import '../../../../common/widgets/show_snack_bar.dart';
import '../../../../common/widgets/wrapper.dart';
import '../../../../config/texts_style.dart';
import '../../../../locator.dart';
import '../../domain/usecase/login_usecase.dart';
import '../bloc/login_bloc/login_bloc.dart';
import '../bloc/login_bloc/login_status.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});


  final GlobalKey<FormState> loginKey = GlobalKey();
  // final GlobalKey<FormState> passwordFormKey = GlobalKey();
  final TextEditingController mobileController = TextEditingController(text: "09032732153");
  final TextEditingController passwordController = TextEditingController(text: "Kk@123456#");

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
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
                      Text("پنل مدیریت هوشمند آب تهران",style: TextStyleP.f14Bold.copyWith(color: ColorPalette.primaryTextGreen),),
                      SizedBox(height: 64.h),

                      Text("ورود به پلتفرم هوشمند مدیریت مصرف آب",style: TextStyleP.f16Medium,),
                      SizedBox(height: 40.h),
                      Text("شماره تماس"),
                      SizedBox(height: 8.h),
                      Form(
                        key: loginKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(

                              controller: mobileController,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (!Constants.validateMobile(value!)) {
                                  return 'لطفا یک شماره تلفن همراه معتبر وارد کنید';
                                }
                                if (value.length < 11 || value.length > 11) {
                                  return 'شماره موبایل باید 11 رقم باشد';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24.h),
                            Text("رمز عبور"),
                            SizedBox(height: 8.h),

                            BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                return TextFormField(
                                  obscureText: state.obscure?true:false,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(onPressed: () {
                                        BlocProvider.of<LoginBloc>(context).add(ObscureClicked(!state.obscure));

                                      }, icon: state.obscure?Icon(Icons.visibility_off_outlined):Icon(Icons.visibility_outlined))
                                  ),


                                  controller: passwordController,
                                  // obscureText: true,
                                  validator: (value) {
                                    if (value!.length < 6 || value.isEmpty ) {
                                      return 'حداقل طول رمز باید ۶ کاراکتر باشد';
                                    }
                                    return null;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),


                      SizedBox(height: 8.h),
                      GestureDetector(onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return EnterMobileScreen();
                        },));

                      },child: SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text("فراموشی رمز عبور؟",textAlign: TextAlign.end,style: TextStyle(color: ColorPalette.darkBlue),)),),
                      SizedBox(height: 15.h),

                      BlocConsumer<LoginBloc, LoginState>(
                        listenWhen: (previous, current) => current.loginStatus != previous.loginStatus,
                        buildWhen: (previous, current) => current.loginStatus != previous.loginStatus,
                        builder: (context, state) {
                          return GlobalElevatedButton(
                            width: double.infinity,
                            onTap: () {
                              if (loginKey.currentState!.validate()) {
                                BlocProvider.of<LoginBloc>(context).add(
                                  ButtonLoginClicked(
                                    LoginParams(
                                      mobile: mobileController.text,
                                      password: passwordController.text,
                                    ),
                                  ),
                                );
                              }
                            },
                            widget: (state.loginStatus is LoginLoading)
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(ConstantTexts.entrance,style: TextStyle(color: Colors.black),),
                            backColor: ColorPalette.darkBlue,
                          );
                        },
                        listener: (BuildContext buildContext, LoginState state) {
                          if (state.loginStatus is LoginSuccess) {

                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
                              return Wrapper();
                            },),(route) => false);
                          }
                          if (state.loginStatus is LoginError) {
                            LoginError authError = state.loginStatus as LoginError;
                            ShowSnacksBars.snack(context, authError.error);
                          }
                        },
                      ),
                      SizedBox(height: 32.h),

                      Row(
                        children: [
                          Text("پنل کاربری ندارید؟ "),
                          GestureDetector(onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return SignUpScreen();
                            },));

                          },child: Text("ثبت نام کنید",style: TextStyle(color: ColorPalette.darkBlue),),)
                        ],
                      )

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
