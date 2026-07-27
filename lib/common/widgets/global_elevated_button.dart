import 'package:flutter/material.dart';

//custom elevatedButton

class GlobalElevatedButton extends StatelessWidget {
  const GlobalElevatedButton({
    super.key,
    this.text,
    required this.widget,
    this.onTap,
    this.backColor,
    this.borderColor,
    this.textColor,
    this.height,
    this.width,
    this.borderRadius,
  });

  final String? text;
  final VoidCallback? onTap;
  final Color? backColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),

              backgroundColor: WidgetStatePropertyAll(backColor),
              shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: borderColor??Colors.transparent,

                )
              )

            )
          ),
          onPressed: onTap,
          child: widget),
    );
  }
}
