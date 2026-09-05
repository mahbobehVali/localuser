import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/icon_container.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../config/color_palette.dart';
import '../../config/texts_style.dart';

class WaterAmountContainer extends StatelessWidget {
  const WaterAmountContainer({
    super.key,
    required this.title,
    required this.amount,
    this.unit = '', // اضافه کردن واحد به‌صورت جداگانه
    this.meter = false,
    this.image ,
    this.year=false ,
  });

  final String title;
  final String amount;
  final String unit;
  final bool meter;
  final String? image;
  final bool year;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100.h,
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: ColorPalette.inverseGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              image==null?SizedBox(): Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                child: IconContainer(icon: Image.asset(image!),color: ColorPalette.inverseBlue,),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
                child: Text(
                  title,
                  style: TextStyleP.f14Bold,
                ),
              ),
            ],
          ),
           SizedBox(height: 10.h),
          Stack(
            children: [
              year?Image.asset("assets/icons/group.png"):SizedBox(),
              Padding(
                padding:  EdgeInsets.only(left: 16.w,bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  textDirection: TextDirection.rtl, // اجبار جهت راست‌به‌چپ برای چینش
                  children: [
                    // ابتدا مقدار عدد
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        amount.toPersianDigit(),
                        style: TextStyleP.f16Bold,
                      ),
                    ),
                     SizedBox(width: 4.w),

                    if (unit.isNotEmpty)
                      Text(
                        unit,
                        style: TextStyleP.f16Bold,
                      ),
                  ],
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}