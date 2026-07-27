import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void customRedScreenError() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // به جای Scaffold از Container یا Material استفاده می‌کنیم
    return Container(
      color: Colors.white, // رنگ پس‌زمینه صفحه خطا
      padding: EdgeInsets.all(20.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // بسیار مهم: جلوی خطای بی‌نهایت شدن ارتفاع را می‌گیرد
          children: [
            Image.asset(
              "assets/images/errorIcon.png",
              width: 100.w,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
            ),
            SizedBox(height: 16.h),
            Material(
              color: Colors.transparent,
              child: Text(
                "مشکلی پیش اومده. در حال بررسی هستیم",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'IranYekan', // مطابق با لاگ شما
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  };
}