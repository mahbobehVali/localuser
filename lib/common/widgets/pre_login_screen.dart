// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../config/texts_style.dart';
// import '../../features/auth_feature/presentation/screens/login/alert_screen.dart';
// import 'global_elevated_button.dart';
//
// class PreLoginScreen extends StatelessWidget {
//   const PreLoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:     Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                     width: 150,
//                     height: 150,
//                     child: SvgPicture.asset("assets/svg/1.svg")) ,
//                 Text("لطفا نوع حساب کاربری خود را مشخص کنید",
//                     style: TextStyleP.f20,
//                     textAlign: TextAlign.center),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 GlobalElevatedButton(
//                   backColor: Color(0xffCAE7E8),
//                   // width: 100,
//                   widget: Text("مشاور",style: TextStyle(color: Colors.black),),
//                   width: double.infinity,
//                   onTap: () async {
//                     // await Navigator.of(context, rootNavigator: true)
//                     //     .push(
//                     //   MaterialPageRoute(
//                     //     builder: (context) {
//                     //       return LoginScreen(type: 2,);
//                     //     },
//                     //   ),
//                     // );
//                     // context.pop();
//                     context.go('/user-panel/pre_login/login');
//
//                     // BlocProvider.of<UserPanelBloc>(context).add(UserPanelStarted());
//                   },
//                 ),
//                 // GlobalElevatedButton(
//                 //   backColor: Color(0xffDFE5E5),
//                 //   width: double.infinity,
//                 //   widget: Text("کاربر",style: TextStyle(color: Colors.black),),
//                 //   onTap: () async {
//                 //     await Navigator.of(context, rootNavigator: true)
//                 //         .push(
//                 //       MaterialPageRoute(
//                 //         builder: (context) {
//                 //           return LoginScreen(type: 1,);
//                 //         },
//                 //       ),
//                 //     );
//                 //     // BlocProvider.of<UserPanelBloc>(context).add(UserPanelStarted());
//                 //   },
//                 // ),
//               ],
//             ),
//           ))
//       ,
//     );
//   }
// }
