import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerticalListviewContent extends StatelessWidget {
  const VerticalListviewContent(
      {super.key,
      required this.listContent,
      required this.onTap,
      this.width,
      });

  final String listContent;
  final GestureTapCallback? onTap;
 final  double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:  EdgeInsets.only(bottom: 11.h),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 43.h,
        width: width,
        decoration: BoxDecoration(
            color: Color(0xffeAeAeA), borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              listContent,
              textAlign: TextAlign.center,
            ),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }
}
