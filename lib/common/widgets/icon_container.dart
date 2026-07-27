import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


// Widget iconContainer(Icon icon, {Color color = const Color(0xffCAE7E8)}){
//   return Container(
//       width: 30.w,
//       height: 30.h,
//       decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(5)
//
//       ),
//       child: icon
//   );
// }

class IconContainer extends StatelessWidget {
  const IconContainer({super.key,
    this.color = const Color(0xffCAE7E8),
    required this.icon,
    this.width=30,
    this.height=30,
    this.borderRadius=5
  });
  final dynamic icon;
  final Color color ;
  final double width ;
  final double height ;
  final double borderRadius ;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),

        ),
        child: icon
    );
  }
}


