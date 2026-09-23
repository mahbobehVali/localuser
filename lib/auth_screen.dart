import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/global_elevated_button.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/auth_feature/presentation/screens/login_screen.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/screens/sign_up/sign_up_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: AlignmentGeometry.topCenter,
              end: AlignmentGeometry.bottomCenter,
              colors: [
            Color(0xff10389C),
            Color(0xff617CA1),

            // ColorPalette.inverseGrey,
          ])
        ),
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/blackLogo.png", width: 150,color: Colors.white,),
              SizedBox(height: 16.h,),
              Text("معاونت خدمات شهری\nسازمان بوستان ها و فضای سبز",style: TextStyleP.f16Bold.copyWith(color: Colors.white),textAlign: TextAlign.center,),
              SizedBox(height: 48.h,),
              Text("سیستم هوشمند مدیریت مصرف آب\nعلمک‌ها و چاه‌ها",style: TextStyleP.f20Bold.copyWith(color: Colors.white),textAlign: TextAlign.center,),
              SizedBox(height: 56.h,),
              GlobalElevatedButton(
                width: MediaQuery.sizeOf(context).width,
                  borderRadius: 5,
                  backColor: ColorPalette.lightBlue,
                  widget: Text("ورود به حساب کاربری", style: TextStyle(color: Colors.black),),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    },));
                  }),

              GlobalElevatedButton(
                width: MediaQuery.sizeOf(context).width,
                  borderRadius: 5,
                  backColor: ColorPalette.inverseGrey,
                  widget: Text("ثبت نام", style: TextStyle(color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    },));
                  }),


            ],
          ),
        ),
      ),
    );
  }
}
