import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/wrapper.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/features/auth_feature/presentation/screens/login_screen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_nav/bottom_nav_cubit.dart';
import 'common/socket_repository.dart';
import 'common/widgets/function_widgets.dart';
import 'features/status_summary_feature/domain/usecase/wells_list_usecase.dart';
import 'features/well_feature/domain/repository/wells_repository.dart';
import 'features/well_feature/domain/usecase/alert_count_usecase.dart';
import 'features/well_feature/domain/usecase/flow_meter_usecase.dart';
import 'features/well_feature/domain/usecase/get_program_usecase.dart';
import 'features/well_feature/domain/usecase/well_work_usecase.dart';
import 'features/well_feature/presentation/bloc/well_detail_bloc/on_off_status.dart';
import 'features/well_feature/presentation/bloc/well_detail_bloc/well_detail_bloc.dart';
import 'locator.dart';


final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  customRedScreenError();
  // ۲. تضمین مقداردهی اولیه بایندینگ‌ها
  WidgetsFlutterBinding.ensureInitialized();

  // ۳. قفل کردن چرخش صفحه روی حالت فقط عمودی
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // اختیاری (معمولاً همین portraitUp کافیست)
  ]).then((_) {
    runApp(const MyApp());
  });

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  final socketRepository = locator<SocketRepository>();
  late WellDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    // سوکت باید فقط یک‌بار در زمان ساخت اپلیکیشن متصل شود
    socketRepository.initAndConnect("manger");
    _bloc = locator<WellDetailBloc>();

  }

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
                // BlocProvider<WellDetailBloc>(create: (_) {
                //    return WellDetailBloc(
                //   locator<WellsRepository>(),
                //   locator<WellWorkHourUseCase>(),
                //   locator<WellFlowMeterUseCase>(),
                //   locator<WellsListUseCase>(),
                //   locator<GetProgramUseCase>(),
                //   socketRepository,
                //   locator<AlertCountUseCase>(),
                // );
                //
                // }),

              ], child: ScreenUtilInit(
                          designSize: const Size(360, 690),
                          minTextAdapt: true,
                          splitScreenMode: true,
                          builder: (context, Widget? child) {

              return child!;
                          },
                          child: MaterialApp(
              scaffoldMessengerKey: rootScaffoldMessengerKey, // این خط را اضافه کنید
                            navigatorObservers: [routeObserver],
              debugShowCheckedModeBanner: false,

              theme: ThemeData(
                  radioTheme: RadioThemeData(

                    fillColor: WidgetStateProperty.all(ColorPalette.darkBlue)
                  ),

                  segmentedButtonTheme: SegmentedButtonThemeData(

                      selectedIcon: SizedBox(),

                      style: SegmentedButton.styleFrom(
                        foregroundColor: Colors.black,
                        selectedForegroundColor: Colors.black,
                        selectedBackgroundColor: ColorPalette.darkBlue,
                        side: BorderSide(
                            color:ColorPalette.lightGrey
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                          // side: BorderSide(color: ColorPalette.lightGrey)
                        ))
                ),


                  fontFamily: 'IranYekan',
                  scaffoldBackgroundColor: ColorPalette.backColor,
                  switchTheme: SwitchThemeData(

                  ),

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
