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
     this.meter=true,
  });

  final String title;
  final String amount;
  final bool meter;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70.h,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: ColorPalette.inverseGrey),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(title,style:  TextStyleP.f14Bold
            ),
           SizedBox(height: 8),

           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(meter==true)  RichText(
                  text:  TextSpan(
                    children: [
                      TextSpan(
                          text: 'm',
                          style:  TextStyleP.f16Bold.copyWith(color: ColorPalette.black)),
                      TextSpan(
                          text: '3',
                          style:  TextStyleP.f16Bold.copyWith(fontFeatures: [FontFeature.superscripts()],
                            color: ColorPalette.black)

                      ),

                    ],
                  ),
                ),
                SizedBox(width: 5,),
                Directionality(
                  textDirection: TextDirection.ltr,
                    child: Text(amount.toPersianDigit(),style:  TextStyleP.f16Bold,textAlign: TextAlign.left,)),
              ],
            ),
          ],
        ));
  }

}
