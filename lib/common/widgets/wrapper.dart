import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/bottom_nav/on_off_wrapper_status.dart';
import 'package:mahaliii/bottom_nav/wrapper_bloc.dart';
import 'package:mahaliii/features/report_feature/presentation/screens/report_screen.dart';
import 'package:mahaliii/features/status_summary_feature/presentation/screens/status_summary_screen.dart';

import '../../bottom_nav/bottom_nav.dart';
import '../../bottom_nav/bottom_nav_cubit.dart';
import '../../features/alert_feature/presentation/screens/alert_screen.dart';
import '../../features/panel_feature/presentation/screens/panel_screen.dart';
import '../../features/well_feature/presentation/bloc/well_detail_bloc/on_off_status.dart';
import '../../features/well_feature/presentation/bloc/well_detail_bloc/well_detail_bloc.dart';
import '../../features/well_feature/presentation/screens/well_screen.dart';
import '../../locator.dart';
import '../socket_repository.dart';
import 'global_snackbar.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key, this.type = 0});

  final int type;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final PageController _pageController;
  late final WellDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    locator<SocketRepository>().initAndConnect("manger");

    _pageController = PageController(initialPage: widget.type);
    BlocProvider.of<WrapperBloc>(context)..add(ChangeNav(widget.type))..add(AutoWrapperSwitchChange());

    // _bloc = locator<WellDetailBloc>();
    //
    // _bloc.add(AutoWrapperSwitchChange());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<WrapperBloc, WrapperState>(
        // 🟢 ۱. این شرط ۱۰۰٪ ضروری است تا فقط زمان تغییر واقعی استیت اسنک‌بار بخورد
        listenWhen: (previous, current) {
          // ۱. بررسی اینکه آیا مقدار isSwitched واقعاً تغییر کرده است یا نه
          final isSwitchChanged = previous.isSwitched != current.isSwitched;

          // ۲. بررسی اینکه وضعیت در حالت Success قرار دارد
          final isSuccess = current.onOffWrapperStatus is OnOffWrapperSuccess;

          return isSwitchChanged && isSuccess;
        },
        listener: (context, state) {
          print("🟢 Socket Switch State Changed: ${state.isSwitched}");

          GlobalSnackBar.show(
            context,
            message: state.isSwitched == true ? "پمپ روشن شد" : "پمپ خاموش شد",
            duration: 2,

          );
        },
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: const [
            StatusSummaryScreen(),
            WellScreen(),
            ReportScreen(),
            AlertScreen(),
            PanelScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavWidget(pageController: _pageController),
    );
  }
}