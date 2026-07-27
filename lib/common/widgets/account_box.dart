import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/color_palette.dart';

class AccountBox extends StatelessWidget {
  const AccountBox({
    super.key,
    required this.name,required this.title
  });
  final String title;
  final String name;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Container(

          width: MediaQuery.sizeOf(context).width*0.75,
          height: 40.h,
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(5)
          ),
          child: Center(child: Text(name,textAlign: TextAlign.center,style: TextStyle(color: ColorPalette.mediumGrey),)),
        )
      ],
    );
  }
}
