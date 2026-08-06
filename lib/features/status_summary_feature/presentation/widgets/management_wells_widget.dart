import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';

import '../../../../common/widgets/icon_container.dart';
import '../../../../config/color_palette.dart';
import '../../../../config/texts_style.dart';
import '../../../auth_feature/presentation/screens/login_screen.dart';
import '../bloc/status_summary_bloc/status_summary_bloc.dart';
import '../bloc/status_summary_bloc/status_summary_status.dart';

class ManagementWellsWidget extends StatelessWidget {
  const ManagementWellsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text("لیست چاه‌های تحت مدیریت",style: TextStyleP.f14Bold),
            ),
            SizedBox(height: 10.h),
            BlocConsumer<StatusSummaryBloc, StatusSummaryState>(
              listener: (context, state) {
                if(state.statusSummaryStatus is StatusSummaryExit){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  },));
                }
              },
              buildWhen: (previous, current) =>
              previous.statusSummaryStatus!=current.statusSummaryStatus,
              listenWhen: (previous, current) =>
              previous.statusSummaryStatus!=current.statusSummaryStatus,
              builder: (context, state) {
                if(state.statusSummaryStatus is StatusSummarySuccess){
                  StatusSummarySuccess statusSummarySuccess=state.statusSummaryStatus as StatusSummarySuccess;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero, // این خط فاصله اضافه را حذف می‌کند

                    itemCount: statusSummarySuccess.wellsEntity.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorPalette.inverseGrey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconContainer(
                              icon: Icon(Icons.location_on_outlined),
                              color: ColorPalette.iconContainerColor,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height:4.h),
                                  Text(statusSummarySuccess.wellsEntity[index].data!.wellName!),

                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("وضعیت: ${statusSummarySuccess.wellsEntity[index].data?.statusWell==1?"روشن":"خاموش"}"),

                                      statusSummarySuccess.wellsEntity[index].data?.alert==0?Text("هشدار فعال: ندارد"): Text(" هشدار فعال: ${statusSummarySuccess.wellsEntity[index].data?.alert} عدد"),

                                    ],
                                  )
                                ],
                              ),
                            )

                          ],
                        ),

                      );
                    },);
                }
                else if(state.statusSummaryStatus is StatusSummaryLoading){
                  return ShimmerClass.shimmerListviewVertical(height: 70,count: 4);

                }
                else if(state.statusSummaryStatus is StatusSummaryError){
                  StatusSummaryError statusSummaryError=state.statusSummaryStatus as StatusSummaryError;
                  return Center(child: Text(statusSummaryError.error));
                }
                else{
                  return Center(child: SizedBox());
                }

              },
            ),
          ],
        ),
      ),
    );
  }
}
