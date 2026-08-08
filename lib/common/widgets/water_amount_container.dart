import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  });

  final String title;
  final String amount;
  final String unit;
  final bool meter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: ColorPalette.inverseGrey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style: TextStyleP.f14Bold,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(width: 4),
              // سپس واحد (ساعت یا m³)
              if (meter)
                Text(
                  'm³',
                  style: TextStyleP.f16Bold.copyWith(color: ColorPalette.black),
                )
              else if (unit.isNotEmpty)
                Text(
                  unit,
                  style: TextStyleP.f16Bold,
                ),
            ],
          ),
        ],
      ),
    );
  }
}