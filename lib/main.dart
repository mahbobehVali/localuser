import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/wrapper.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/features/auth_feature/presentation/screens/login_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_nav/bottom_nav_cubit.dart';
import 'common/widgets/function_widgets.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  customRedScreenError();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, asyncSnapshot) {
        if(asyncSnapshot.hasData){
          String token= asyncSnapshot.data!.getString("token")??"";

          return MultiBlocProvider(
              providers: [
                BlocProvider<BottomNavCubit>(create: (_) => BottomNavCubit()),

              ], child: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, Widget? child) {

              return child!;
            },
            child: MaterialApp(

              debugShowCheckedModeBanner: false,

              theme: ThemeData(
                  radioTheme: RadioThemeData(

                    fillColor: WidgetStateProperty.all(ColorPalette.darkBlue), // رنگی که می‌خوای (مثلاً قرمز)
                  ),
                segmentedButtonTheme: SegmentedButtonThemeData(
                    style: SegmentedButton.styleFrom(
                        foregroundColor: Colors.black,
                        selectedForegroundColor: Colors.black,
                        selectedBackgroundColor: ColorPalette.darkBlue,
                        side:  BorderSide(
                            color: ColorPalette.inverseGrey
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ))
                ),


                  fontFamily: 'IranYekan',
                  scaffoldBackgroundColor: ColorPalette.backColor,

                  appBarTheme: AppBarTheme(
                      backgroundColor: ColorPalette.backColor,
                      scrolledUnderElevation: 0
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(5)

                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey,width: 1),
                    borderRadius: BorderRadius.circular(5)

                ),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red,width: 1),
                    borderRadius: BorderRadius.circular(5)

                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red,width: 1),
                    borderRadius: BorderRadius.circular(5)

                ),
              )),
              themeMode: ThemeMode.system, // هماهنگی خودکار با سیستم‌عامل کاربر

                localizationsDelegates: const [
                // Add Localization
                PersianMaterialLocalizations.delegate,
                PersianCupertinoLocalizations.delegate,

                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale("fa", "IR"), // فارسی
              ],
              locale: const Locale("fa", "IR"), // زبان پیش‌فرض برنامه

              home: token.isEmpty? LoginScreen():Wrapper(),
            ),
          ));
        }else{
          return CircularProgressIndicator();
        }
      }
    );
  }

}
