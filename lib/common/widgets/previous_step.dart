import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'global_elevated_button.dart';

class PreviousStep extends StatelessWidget {
  const PreviousStep({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GlobalElevatedButton(
      widget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: const Text(
          "مرحله قبل",
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
      backColor: Colors.teal,
    );
  }
}