import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/area_usecase.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/region_usecase.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/screens/sign_up/register_screen.dart';

import '../../../../../common/utils/constants.dart';
import '../../../../../locator.dart';
import '../../../domain/usecase/first_sign_up.dart';
import '../../../domain/usecase/register_usecase.dart';
import '../../bloc/sign_up_bloc.dart';
import 'first_sign_up.dart';

class SignUpScreen extends StatelessWidget {
   SignUpScreen({super.key});

  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) {
        SignUpBloc signUpBloc = SignUpBloc(
          locator<RegisterUseCase>(),
          // locator<AgainSendValidationCodeUseCase>(),
          locator<FirstSignupUseCase>(),
          // locator<ValidationUseCase>(),
          locator<AreaUseCase>(),
          locator<RegionUseCase>(),

        );

        signUpBloc.add(GetRegion());
        return signUpBloc;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset("assets/images/logo.png",width: 28,),
                  SizedBox(
                    width: 14.w,
                  ),
                  Text(
                    "پنل مدیریت هوشمند آب شهرداری تهران",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                "ثبت نام در پلتفرم هوشمند مدیریت مصرف آب",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24.h),

              BlocBuilder<SignUpBloc, SignUpState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(2, (index) {
                      return Padding(
                        padding:  EdgeInsets.only(left:10.w),
                        child: Row(
                          children: [
                            Text(Constants().signUpConstant[index],style: TextStyle(
                              color: state.step==index?ColorPalette.darkBlue:Colors.black
                            ),),
                            state.step==1?SizedBox():Icon(Icons.arrow_forward_ios)

                          ],
                        ),
                      );
                    },),
                  );
                },
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    FirstSignUp(pageController: pageController),
                    // ValidationCodeScreen(pageController: pageController),

                    RegisterScreen(pageController: pageController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
