import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/widgets/last_activity_widget.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../bloc/report_bloc.dart';
import '../bloc/user_activity_report_status.dart';

class LastActivity extends StatelessWidget {
  const LastActivity({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: Constants().whiteFiveRadiusDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("آخرین فعالیت های انجام شده", style: TextStyleP.f12Regular),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(border: Border.all(color: ColorPalette.grey), borderRadius: BorderRadius.circular(5)),
            child: BlocBuilder<ReportBloc, ReportState>(
              buildWhen: (prev, curr) =>
              prev.selectedLastActivityPage != curr.selectedLastActivityPage ||
                  prev.userActivityReportStatus != curr.userActivityReportStatus,
              builder: (context, state) {
                print(state.userActivityReportStatus);
                final status = state.userActivityReportStatus;
                if (status is UserActivityReportSuccess) {
                  return Column(
                    children: [
                      LastActivityWidget(lastActivityEntity: status.lastActivityEntity),
                      PaginationWidget(
                        selected: state.selectedLastActivityPage!,
                        lastPage: status.lastActivityEntity.lastPage!,
                        onPageChanged: (newPage) {
                          context.read<ReportBloc>().add(UserActivityReportStart(state.flowMeterParams!.copyWith(newPage: newPage)));
                        },
                      )
                    ],
                  );
                }
                if (status is UserActivityReportEmpty) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: Text("فعالیتی وجود ندارد", style: TextStyleP.f16Medium)),
                  );
                }
                if (status is UserActivityReportError) return Center(child: Text(status.error));
                return const Center(child: SizedBox.shrink());
              },
            ),
          ),
        ],
      ),
    );
  }
}
