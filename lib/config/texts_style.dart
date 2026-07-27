import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


String fontFamily="IRANYekan";

abstract class TextStyleP {
  Widget text_12(String text){
    return Text(text,style: f12Regular);
  }

  Widget text_10(String text){
    return Text(text,style:f10Regular);
  }

  Widget text_16(String text){
    return Text(text,style: f16Medium);
  }


  static TextStyle f14Bold =
  TextStyle(fontFamily: fontFamily,fontSize: 14.sp, fontWeight: FontWeight.bold);

  static TextStyle f16Medium =
  TextStyle(fontFamily: fontFamily,fontSize: 16.sp, fontWeight: FontWeight.w500);
  static TextStyle f16Bold =
  TextStyle(fontFamily: fontFamily,fontSize: 16.sp, fontWeight: FontWeight.bold);
static TextStyle f12Regular =
  TextStyle(fontFamily: fontFamily,fontSize: 12.sp, fontWeight: FontWeight.w400);
static TextStyle f10Regular =
  TextStyle(fontFamily: fontFamily,fontSize: 10.sp, fontWeight: FontWeight.w400);
static TextStyle f8Medium =
  TextStyle(fontFamily: fontFamily,fontSize: 8.sp, fontWeight: FontWeight.w500);



  static TextStyle height14 = const TextStyle(height: 1.4);

  static TextStyle colorW = const TextStyle(color: Colors.white);

  static TextStyle colorBlack = const TextStyle(color: Colors.black);

  static TextStyle colorTeal = const TextStyle(color: Colors.teal);
  static TextStyle colorBf12 = const TextStyle(color: Colors.black, fontSize: 12);
  static TextStyle colorBf15 = const TextStyle(color: Colors.black, fontSize: 11);
}
