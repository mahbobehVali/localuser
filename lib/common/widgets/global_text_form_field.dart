// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../config/texts_style.dart';
//
// //custom textFormField
// class GlobalTextFormField extends StatelessWidget {
//   GlobalTextFormField(
//       {super.key,
//       this.label,
//       this.hint,
//       this.title,
//       this.controller,
//       this.read,
//       this.validator,
//       this.suffixIcon,
//       this.fill,
//       this.autoValue,
//       this.focusNodeValue,
//       this.fillColor,
//       this.onChange,
//       this.borderColor,
//       this.borderRadius,
//       this.floatingLabelBehavior,
//       this.keyBoardType,
//       this.max,
//       this.obscureText,
//       this.scrollController,
//       this.onChanged,
//       this.inputFormatters,
//       this.text,
//       this.maxL,
//       this.textAlign});
//
//   String? label;
//   String? text;
//   String? hint;
//   String? title;
//   TextEditingController? controller;
//   bool? read;
//   bool? obscureText;
//   FormFieldValidator<String>? validator;
//   Widget? suffixIcon;
//   bool? fill;
//   bool? autoValue;
//   FocusNode? focusNodeValue;
//   Color? fillColor;
//   Color? borderColor;
//   BorderRadius? borderRadius;
//   ValueChanged<String>? onChange;
//   TextInputType? keyBoardType;
//   FloatingLabelBehavior? floatingLabelBehavior;
//   int? max;
//   int? maxL;
//   ScrollController? scrollController = ScrollController();
//   ValueChanged<String>? onChanged;
//   List<TextInputFormatter>? inputFormatters;
//   TextAlign? textAlign;
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       initialValue: text,
//       maxLength: maxL,
//       textAlign: textAlign??TextAlign.start,
//
//
//       scrollController: scrollController,
//       onChanged: onChanged,
//
//       // obscureText: obscureText??false,
//       minLines: 1,
//       maxLines: max,
//       keyboardType: keyBoardType,
//       //autofocus: autoValue ?? false,
//       // focusNode: focusNodeValue,
//       textDirection: TextDirection.rtl,
//
//       validator: validator,
//       readOnly: read != null ? read! : false,
//       controller: controller,
//       cursorColor: Colors.black,
//       cursorHeight: 20,
//       inputFormatters: inputFormatters,
//       decoration: InputDecoration(
//
//         floatingLabelBehavior: floatingLabelBehavior,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//         contentPadding:
//             const EdgeInsets.only(right: 10, bottom: 10, top: 10, left: 10),
//         suffixIcon: suffixIcon,
//         hintText: hint ?? "",
//         hintStyle: TextStyleP.colorBf12,
//         filled: fill,
//         fillColor: fillColor,
//         labelText: label ?? "",
//         labelStyle: TextStyleP.colorBf15,
//         focusedErrorBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//               color: Colors.red,
//             ),
//             borderRadius: borderRadius != null
//                 ? borderRadius!
//                 : BorderRadius.circular(5)),
//         enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: borderColor != null ? borderColor! : Colors.grey,
//             ),
//             borderRadius: borderRadius != null
//                 ? borderRadius!
//                 : BorderRadius.circular(5)),
//         focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: borderColor != null ? borderColor! : Colors.grey,
//             ),
//             borderRadius: borderRadius != null
//                 ? borderRadius!
//                 : BorderRadius.circular(5)),
//         errorBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//               color: Colors.red,
//             ),
//             borderRadius: borderRadius != null
//                 ? borderRadius!
//                 : BorderRadius.circular(5)),
//       ),
//     );
//   }
// }
