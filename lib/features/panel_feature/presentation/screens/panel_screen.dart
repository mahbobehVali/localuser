import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/show_dialogs.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/panel_feature/presentation/cubit/logout_cubit.dart';
import 'package:mahaliii/features/panel_feature/presentation/screens/account_screen.dart';
import 'package:mahaliii/features/support_feature/presentation/screens/support_screen.dart';

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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return AccountScreen();
                    },));
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Color(0xffD3D9E0),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Row(
                          children: [
                            IconContainer(
                              icon: Image.asset("assets/icons/user-square.png"),
                              color: Colors.transparent,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 9),

                            Text("اطلاعات حساب کاربری"),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return SupportScreen();
                    },));
                  },
                  child: Container(
                    height: 40.h,
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Color(0xffD3D9E0),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Row(
                          children: [
                            IconContainer(
                              // icon: Icon(Icons.account_box_outlined),
                              // icon: Icon(CupertinoIcons.person_crop_square),
                              icon: Image.asset("assets/icons/user-square.png"),
                              color: Colors.transparent,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 9),

                            Text("پشتیبانی"),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32),



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
                            color: Color(0xffD3D9E0),
                            borderRadius: BorderRadius.circular(8),
                          ),

                          child: Row(
                            children: [
                              IconContainer(
                                icon: Icon(Icons.logout_rounded),
                                // icon: Image.asset("assets/icons/Logout.png"),
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

