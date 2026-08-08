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
      child: BlocBuilder<ReportBloc, ReportState>(
        buildWhen: (prev, curr) =>
        prev.selectedLastActivityPage != curr.selectedLastActivityPage ||
            prev.userActivityReportStatus != curr.userActivityReportStatus,
        builder: (context, state) {
          final status = state.userActivityReportStatus;
          if (status is UserActivityReportSuccess) {
            return Column(
              children: [

                LastActivityWidget(lastActivityEntity: status.lastActivityEntity,report:true),
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
            return Constants.noData();
          }
          if (status is UserActivityReportError) return Center(child: Text(status.error));
          return const Center(child: SizedBox.shrink());
        },
      ),
    );
  }
}
