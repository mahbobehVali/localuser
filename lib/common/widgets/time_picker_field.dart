import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimePickerField extends StatelessWidget {
  final String title;
  final String displayText;
  final bool ignoring;
  final VoidCallback onTap;

  const TimePickerField({
    super.key,
    required this.title,
    required this.displayText,
     this.ignoring=false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
           SizedBox(height: 8.h),
          IgnorePointer(
            ignoring: ignoring,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5), // اختیاری برای ظاهر بهتر
                ),
                child: Center(
                  child: Text(displayText),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}