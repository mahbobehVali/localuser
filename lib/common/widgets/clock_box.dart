import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/config/color_palette.dart';

class ClockBox extends StatelessWidget {
  const ClockBox({super.key, required this.clock,required this.time});
  final String clock;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(clock),
          SizedBox(height: 8.h),

          Container(
            // width: 88.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: Center(child: Text(time)),
          ),
        ],
      ),
    );
  }
}
