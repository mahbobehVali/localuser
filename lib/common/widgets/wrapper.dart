import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahaliii/features/report_feature/presentation/screens/report_screen.dart';
import 'package:mahaliii/features/status_summary_feature/presentation/screens/status_summary_screen.dart';

import '../../bottom_nav/bottom_nav.dart';
import '../../bottom_nav/bottom_nav_cubit.dart';
import '../../features/alert_feature/presentation/screens/alert_screen.dart';
import '../../features/panel_feature/presentation/screens/panel_screen.dart';
import '../../features/well_feature/presentation/screens/well_screen.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({super.key, this.type = 0});

 final int type;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final PageController _pageController;


  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.type);
    BlocProvider.of<BottomNavCubit>(context).change(widget.type);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // در اولین لایه برنامه‌ یا زمان مقداردهی اولیه (مثلاً در Splash Screen یا HomeScreen)
    // SocketRepository().initAndConnect();
    // PageController pageController = PageController(initialPage: widget.type);
    // BlocProvider.of<BottomNavCubit>(context).change(widget.type);
    //

    // if (type==3) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     pageController.animateToPage(3,
    //         duration: const Duration(microseconds: 5), curve: Curves.easeInBack);
    //   });
    // }

    return Scaffold(
        body: PageView(

          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            // SignUpScreen(),
            StatusSummaryScreen(),
            WellScreen(),
            ReportScreen(),
            AlertScreen(),
            PanelScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavWidget(pageController: _pageController)
    );
  }
}
