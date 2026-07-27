import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowSnacksBars{
  // GlobalKey<NavigatorState> navigatorKey=GlobalKey<NavigatorState>();
  // final snackService =ShowSnacksBars();
  //
  // void showsnackbar(String m){
  //   ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(content: Text(m)));
  // }



///for success status, color should be sent
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snack(BuildContext context,String message,
      {int? duration,Color? color}){

    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(


        behavior: SnackBarBehavior.floating, // حتما باید روی floating باشد
        dismissDirection: DismissDirection.down, // قابلیت کشیدن به پایین
        duration: Duration(
          seconds: duration??1,
        ),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(),
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,
        margin: EdgeInsets.only(
            bottom: 30.h,
            left: 20,
            right: 20),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(color==null?Icons.cancel_outlined: Icons.check_circle_outline,color: color??Colors.red,),
            SizedBox(width:10.w),
            Expanded(child: Text(message,style: TextStyle(color: Colors.black),)),
          ],
        )),);
  }

}