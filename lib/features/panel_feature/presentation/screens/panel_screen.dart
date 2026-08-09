import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/show_dialogs.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/panel_feature/presentation/cubit/logout_cubit.dart';
import 'package:mahaliii/features/panel_feature/presentation/screens/account_screen.dart';
import 'package:mahaliii/features/support_feature/presentation/screens/support_screen.dart';

import '../../../../common/widgets/global_snackbar.dart';
import '../../../../common/widgets/icon_container.dart';


class PanelScreen extends StatefulWidget {
  const PanelScreen({super.key});

  @override
  State<PanelScreen> createState() => _PanelScreenState();
}

class _PanelScreenState extends State<PanelScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body:Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: Text("پنل کاربری",style: TextStyleP.f16Medium,),
                ),

                RowBox(onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return AccountScreen();
                  },));
                },
                    image: Image.asset("assets/icons/user.png"),
                    title: "اطلاعات حساب کاربری"),
                SizedBox(height: 15.h),
                RowBox(onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return SupportScreen();
                  },));
                },
                image: Image.asset("assets/icons/vector.png"),
                title: "پشتیبانی"),
                SizedBox(height: 15.h),
                RowBox(onTap: () {
                  GlobalSnackBar.show(context, message: "این بخش به زودی فعال خواهد شد");

                },
                    image: Icon(Icons.contact_support_outlined),
                    title: "سوالات متداول"),
                SizedBox(height: 15.h),

                BlocProvider<LogoutCubit>(
                  create: (context) => LogoutCubit(),
                  child: Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          ShowDialogs().exitShowDialog(
                            context,
                            BlocProvider.of<LogoutCubit>(context),
                          );
                        },
                        child: Container(
                          height: 40.h,
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: ColorPalette.tGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Row(
                            children: [
                              IconContainer(
                                icon: Icon(Icons.logout_rounded),
                                color: Colors.transparent,
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 9),

                              Text("خروج از حساب کاربری"),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class RowBox extends StatelessWidget {
  const RowBox({
    super.key,
    required this.onTap,
    required this.image,
    required this.title,

  });

  final GestureTapCallback onTap;
  final dynamic image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: ColorPalette.tGrey,
          borderRadius: BorderRadius.circular(8),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Row(
              children: [
                IconContainer(

                  icon: image,
                  color: Colors.transparent,
                  width: 24,
                  height: 24,
                ),
                SizedBox(width: 9.w),
                Text(title)
              ],
            ),
            
            Icon(Icons.navigate_next)

          ],
        ),
      ),
    );
  }
}

