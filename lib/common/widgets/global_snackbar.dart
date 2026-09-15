import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalSnackBar {
  // متد را به صورت استاتیک تعریف می‌کنیم تا بدون ساختن نمونه شیء، قابل صدا زدن باشد
  static void show(BuildContext context, {required String message, int duration=3, EdgeInsetsGeometry margin=const EdgeInsets.only(
    left: 20,
    right: 20,
  )}) {

    // قبل از نمایش اسنک‌بار جدید، قبلی‌ها را می‌بندیم تا صفی از اسنک‌بارها درست نشود
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,


        behavior: SnackBarBehavior.floating,
        duration:  Duration(seconds: duration),
        elevation: 0,
        backgroundColor: Color(0xff5F8CC5),
        margin: margin,
        content: Text(
          message,
          textAlign: TextAlign.center, // برای زیبایی بیشتر متون فارسی
          style: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'IranYekan', // اگر فونت اختصاصی دارید
          ),
        ),
      ),
    );
  }
}