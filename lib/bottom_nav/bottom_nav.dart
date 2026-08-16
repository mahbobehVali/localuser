import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';

import 'bottom_nav_cubit.dart';

class BottomNavWidget extends StatelessWidget {

  const BottomNavWidget({super.key,required this.pageController});
  final PageController pageController;



  static const List bottomNavItems = [
    {
      "title": "وضعیت کلی",
      "icon": "assets/icons/home.png"
    },
    {
      "title": "چاه ها",
      "icon": "assets/icons/menu.png"
    },{
      "title": "گزارش ها",
      "icon": "assets/icons/Chart.png"
    },
    {
      "title": "هشدارها",
      "icon": "assets/icons/Notification.png"
    },{
      "title": "پنل کاربر",
      "icon": "assets/icons/user-square.png"
    },

  ];

  static const List activeBottomNavItems = [
    {
      "title": "وضعیت کلی",
      "icon": "assets/icons/activeHome.png"
    },
    {
      "title": "چاه ها",
      "icon": "assets/icons/Category.png"
    },{
      "title": "گزارش ها",
      "icon": "assets/icons/activeChart.png"
    },
    {
      "title": "هشدارها",
      "icon": "assets/icons/activeNotification.png"
    },{
      "title": "پنل کاربر",
      "icon": "assets/icons/active_user-square.png"
    },

  ];


  @override
  Widget build(BuildContext context) {

    return BlocBuilder<BottomNavCubit, int>(
      buildWhen: (previous, current) => previous!=current,
      builder: (context, state) {

        return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(offset: Offset(0, 1),blurRadius: 5,color: Color(0xffDDDDDD))
          ]),
          child: BottomAppBar(
            padding: EdgeInsets.only(right: 10.w,bottom: 4.h,top: 4.h),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(bottomNavItems.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        SizedBox(
                            child: Image.asset(state==index?activeBottomNavItems[index]["icon"]:bottomNavItems[index]["icon"],
                                color: state==index?ColorPalette.darkBlue:Colors.black)),
                        SizedBox(height: 6.h),
                        Text(bottomNavItems[index]["title"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                          color: state==index?ColorPalette.darkBlue:Colors.black,
                          fontWeight: FontWeight.w500
                        ),),
                      if(state==index)  Container(
                          margin: EdgeInsets.all(5),
                          height: 3.h,
                          color: ColorPalette.darkBlue,
                        )
                      ],
                    ),
                    onTap: () {
                      BlocProvider.of<BottomNavCubit>(context).change(index);

                      pageController.animateToPage(index,
                          duration: const Duration(microseconds: 500), curve: Curves.easeIn);

                    },
                  ),
                );
              },),
            ),
          ),
        );
      },
    );
  }
}
