import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'global_elevated_button.dart';

class RefuseButton extends StatelessWidget {
    RefuseButton({
    super.key,
     this.onTap,
     this.width,
     this.text,
     this.borderRadius= 20,

   });
   final VoidCallback? onTap;
   final double? width;
   final String? text;
   double? borderRadius;



   @override
  Widget build(BuildContext context) {
    return GlobalElevatedButton(
      borderRadius: borderRadius,
        onTap: onTap??() {
          Navigator.of(context).pop();
        },

        widget: Text(text??"انصراف",
            style: TextStyle(
                color: Colors.white,fontSize: 14)),
        backColor: Colors.grey,
        width: width??130.w,);
  }
}