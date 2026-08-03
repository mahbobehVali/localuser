import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';

class SelectImageWidget extends StatelessWidget {
  SelectImageWidget({
    super.key,
    required this.image,
    required this.onTap,
    this.borderRadius,
    this.clipBorderRadius,
    this.width,
    this.height,
  });

  // از final استفاده می شود زیرا این ها ویژگی های StatelessWidget هستند
  final String? image;
  final GestureTapCallback? onTap;
  final double? borderRadius;
  final double? clipBorderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.teal,
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(5),
            border: BoxBorder.all(color: ColorPalette.inverseGrey),),
        
        
        child:  _buildImageContent()
      ),
    );
  }

  // متد کمکی برای مدیریت منطق نمایش تصویر
  Widget _buildImageContent() {
    if (image==null || image!.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(Icons.upload_file),
            SizedBox(height: 10.h),
            Text("بارگذاری فایل ضمیمه")
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.check),
      );
    }
  }
}