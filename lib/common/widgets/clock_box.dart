import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          Container(
            width: 88.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(),
            ),
            child: Center(child: Text(time)),
          ),
        ],
      ),
    );
  }
}
