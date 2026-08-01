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
  final String image;
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
        
        
        child:  Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(Icons.upload_file),
              SizedBox(height: 10.h),
              Text("بارگذاری فایل ضمیمه")
            ],
          ),
        ),
      ),
    );
  }

  // متد کمکی برای مدیریت منطق نمایش تصویر
  Widget _buildImageContent() {
    if (image.isEmpty) {
      return const Icon(
        Icons.add_photo_alternate_outlined,
        size: 30,
        color: Colors.grey,
      );
    } else if (image.startsWith("http")) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.error, color: Colors.red),
      );
    } else {
      return Image.file(
        File(image),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.error, color: Colors.red),
      );
    }
  }
}