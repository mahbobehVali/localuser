// import 'package:flutter/material.dart';
//
// import '../../config/color_palette.dart';
//
// class RadioRow extends StatelessWidget {
//   RadioRow({
//     super.key,
//     required this.list
//   });
//   List<String> list;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//
//       children: List.generate(list.length, (index) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             // اینجا رنگ رادیو رو برای این دکمه خاص ست می‌کنیم
//             radioTheme: RadioThemeData(
//
//               fillColor: WidgetStateProperty.all(ColorPalette.primaryBlue), // رنگی که می‌خوای (مثلاً قرمز)
//             ),
//           ),
//           child: RadioMenuButton(
//             value: 1,
//             groupValue: 1,
//             onChanged: (value) {
//
//             },
//             child: Text(list[index]),
//           ),
//         );
//       },),
//     );
//   }
// }
