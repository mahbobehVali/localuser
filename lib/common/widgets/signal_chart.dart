import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';

class SignalBarChart extends StatelessWidget {
  /// عددی بین 1 تا 5 برای فعال‌سازی میله‌ها
  final int value;

  const SignalBarChart({
    super.key,
    required this.value,
  }) : assert(value >= 0 && value <= 6, 'مقدار باید بین 0 تا 5 باشد');

  @override
  Widget build(BuildContext context) {
    // ارتفاع نسبی ۵ میله به ترتیب از چپ به راست (مشابه تصویر)
    final List<double> heights = [0.20,0.30, 0.48, 0.65, 0.82, 1.0];

    return Container(
      height: 130,
      padding:  EdgeInsets.symmetric(vertical: 12.h),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(6, (index) {
          // اگر اندیس میله کمتر از عدد ورودی باشد سبز، در غیر این صورت طوسی می‌شود
          final bool isActive = index < value;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.5),
            child: FractionallySizedBox(
              heightFactor: heights[index],
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300), // انیمیشن تغییر رنگ
                width: 12.w, // عرض هر میله
                decoration: BoxDecoration(
                  color: isActive
                      ? ColorPalette.darkGreen // سبز
                      : ColorPalette.lightGrey, // طوسی
                  borderRadius: BorderRadius.circular(1), // گوشه‌های گرد میله
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}