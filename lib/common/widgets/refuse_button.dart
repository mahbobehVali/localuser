import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'global_elevated_button.dart';

class RefuseButton extends StatelessWidget {
   const RefuseButton({
    super.key,
     this.onTap,
     this.width,
     this.text,
  });
   final VoidCallback? onTap;
   final double? width;
   final String? text;


  @override
  Widget build(BuildContext context) {
    return GlobalElevatedButton(
        onTap: onTap??() {
          Navigator.of(context).pop();
        },
        widget: Text(text??"انصراف",
            style: TextStyle(
                color: Colors.white,fontSize: 18)),
        backColor: Colors.grey,
        width: width??130.w,);
  }
}