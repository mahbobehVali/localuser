import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/color_palette.dart';

class AccountBoxTitle extends StatelessWidget {
  const AccountBoxTitle({
    super.key,
    required this.title,
    required this.titleIcon,
     this.divider=true,
    this.color,
     this.onTap
  });
  final String title;
  final String titleIcon;
  final bool divider;
  final Color? color;
  final GestureTapCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(4),
            height: 29.h,
            decoration: BoxDecoration(
              color: color??ColorPalette.lightBlue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // فاصله از چپ و راست
              child: Row(
                mainAxisSize: MainAxisSize.min, // حیاتی: برای اینکه کانتینر عرض کل را نگیرد
                children: [
                  // باکس آیکون با ابعاد دقیق
                  SizedBox(
                    width: 16.w,
                    // height: 16,
                    child: Image.asset(
                      titleIcon,
                      fit: BoxFit.contain, // مهار کردن عکس در باکس ۱۶ در ۱۶
                    ),
                  ),

                  // ایجاد فاصله بین آیکون و متن
                  SizedBox(width: 8),

                  // نمایش عنوان
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

         divider?Divider(height: 20):SizedBox(), // خط جداکننده زیر ردیف
      ],
    );
  }
}
