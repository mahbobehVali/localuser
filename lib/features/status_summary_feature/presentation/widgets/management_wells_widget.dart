import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/bottom_nav/wrapper_bloc.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/features/well_feature/presentation/screens/well_detail_screen.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/socket_repository.dart';
import '../../../../common/utils/sharedpreference.dart';
import '../../../../common/widgets/icon_container.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../../../../locator.dart';
import '../../../auth_feature/presentation/screens/login_screen.dart';
import '../bloc/status_summary_bloc/status_summary_bloc.dart';
import '../bloc/status_summary_bloc/status_summary_status.dart';

class ManagementWellsWidget extends StatefulWidget {
  const ManagementWellsWidget({super.key});

  @override
  State<ManagementWellsWidget> createState() => _ManagementWellsWidgetState();
}

class _ManagementWellsWidgetState extends State<ManagementWellsWidget> {

  @override
  void initState() {
    super.initState();
    // 🟢 اگر استیت از قبل موفق بوده، مستقیم همان اول به WrapperBloc پاس بدهید
    final statusSummaryBloc = BlocProvider.of<StatusSummaryBloc>(context);
    if (statusSummaryBloc.state.statusSummaryStatus is StatusSummarySuccess) {
      final successState = statusSummaryBloc.state.statusSummaryStatus as StatusSummarySuccess;
      BlocProvider.of<WrapperBloc>(context).add(SetInitialWellsEvent(successState.wellsEntity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text("لیست چاه‌های تحت مدیریت", style: TextStyleP.f14Medium),
            ),
            SizedBox(height: 10.h),

            // ۱. لیسنر برای مواقعی که دیتا بعد از ساخته شدن این صفحه از API می‌رسد
            BlocListener<StatusSummaryBloc, StatusSummaryState>(
              listener: (context, state) async {
                if (state.statusSummaryStatus is StatusSummaryExit) {
                  // ۱. قطع سوکت و پاک‌سازی هدرها
                  await locator<SocketRepository>().logout();

                  // ۲. 🔑 پاک کردن توکن و اطلاعات کاربر از SharedPreferences (بسیار مهم)
                  await locator<SharedPrefOperator>().logout();

                  // ۳. هدایت به صفحه لاگین
                  if (context.mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                }

                if (state.statusSummaryStatus is StatusSummarySuccess) {
                  StatusSummarySuccess statusSummarySuccess =
                  state.statusSummaryStatus as StatusSummarySuccess;

                  BlocProvider.of<WrapperBloc>(context)
                      .add(SetInitialWellsEvent(statusSummarySuccess.wellsEntity));
                }
              },
              child: BlocBuilder<StatusSummaryBloc, StatusSummaryState>(
                builder: (context, statusState) {
                  // ۲. اگر API کلاً به خطا خورده بود
                  if (statusState.statusSummaryStatus is StatusSummaryError) {
                    final errorState = statusState.statusSummaryStatus as StatusSummaryError;
                    return Center(child: Text(errorState.error));
                  }

                  // ۳. اگر API هنوز در حال لودینگ است
                  if (statusState.statusSummaryStatus is StatusSummaryLoading) {
                    return ShimmerClass.shimmerListviewVertical(height: 70, count: 4);
                  }

                  // ۴. ساخت لیست از WrapperBloc (که چاه‌ها را با سوکت به‌روز نگه می‌دارد)
                  if(statusState.statusSummaryStatus is StatusSummarySuccess){
                    return BlocBuilder<WrapperBloc, WrapperState>(
                      builder: (context, wrapperState) {
                        if (wrapperState.wells.isEmpty) {
                          return ShimmerClass.shimmerListviewVertical(height: 70, count: 4);
                        }

                        final wellsList = wrapperState.wells;

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: wellsList.length,
                          itemBuilder: (indexContext, index) {
                            final wellData = wellsList[index].data;
                            final alertCount = wellData?.alert ?? 0;

                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WellDetailScreen(
                                      wellsDataEntity: wellData!,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorPalette.inverseGrey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        IconContainer(
                                          icon: const Icon(Icons.location_on_outlined),
                                          color: ColorPalette.iconContainerColor,
                                          width: 24,
                                          height: 24,
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 4.h),
                                              Text(wellData?.wellName ?? ''),
                                              SizedBox(height: 8.h),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text.rich(
                                                    TextSpan(
                                                      text: 'وضعیت: ',
                                                      style: const TextStyle(color: Colors.black),
                                                      children: [
                                                        TextSpan(
                                                          text: wellData?.statusWell == 0
                                                              ? 'خاموش'
                                                              : wellData?.statusWell == 1
                                                              ? 'روشن'
                                                              : "غیر فعال",
                                                          style: TextStyle(
                                                            color: wellData?.statusWell == 0
                                                                ? ColorPalette.darkRed
                                                                : wellData?.statusWell == 1
                                                                ? ColorPalette.darkGreen
                                                                : ColorPalette.orange,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    alertCount == 0
                                                        ? 'هشدار فعال: ندارد'
                                                        : 'هشدار فعال: ${alertCount.toString().toPersianDigit()} عدد',
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.h),
                                      child: DottedLine(
                                        dashColor: ColorPalette.inverseGrey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("مشاهده چاه"),
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              border: BoxBorder.all()
                                            ),
                                            child: const Icon(Icons.navigate_next))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
