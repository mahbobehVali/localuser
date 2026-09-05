import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/socket_repository.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/well_detail_bloc.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/well_status.dart';
import 'package:mahaliii/features/well_feature/presentation/screens/well_detail_screen.dart';

import '../../../../common/utils/sharedpreference.dart';
import '../../../../locator.dart';
import '../../../auth_feature/presentation/screens/login_screen.dart';
import '../../../status_summary_feature/domain/usecase/wells_list_usecase.dart';
import '../../domain/repository/wells_repository.dart';
import '../../domain/usecase/alert_count_usecase.dart';
import '../../domain/usecase/flow_meter_usecase.dart';
import '../../domain/usecase/get_program_usecase.dart';
import '../../domain/usecase/well_work_usecase.dart';

class WellScreen extends StatefulWidget {
  const WellScreen({super.key});

  @override
  State<WellScreen> createState() => _WellScreenState();
}

class _WellScreenState extends State<WellScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocProvider<WellDetailBloc>(
        create: (context) {
          WellDetailBloc wellBloc= locator<WellDetailBloc>();
          wellBloc.add(WellStart());
          return wellBloc;
        },
        child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 64.h,horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text("لیست چاه‌های تحت مدیریت",style: TextStyleP.f16Bold,),
              SizedBox(height: 16.h),

              Text("برای دسترسی به اطلاعات چاه مورد نظر خود بر روی آن کلیک کنید.",style: TextStyleP.f12Regular,),

              SizedBox(height: 34.h),

              Expanded(
                child: BlocConsumer<WellDetailBloc, WellDetailState>(
                  listener: (context, state) {
                    if(state.wellStatus is WellExit){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      },));
                    }
                  },
                  builder: (context, state) {
                    if(state.wellStatus is WellSuccess){
                      WellSuccess statusSummarySuccess=state.wellStatus as WellSuccess;
                      return ListView.builder(
                        padding: EdgeInsets.zero, // این خط فاصله اضافه را حذف می‌کند
                        itemCount: statusSummarySuccess.wellsEntity.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () async {
                                await locator<SharedPrefOperator>().saveSwitch(statusSummarySuccess.wellsEntity[index].data!.statusWell == 1);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WellDetailScreen(
                                      wellsDataEntity: statusSummarySuccess.wellsEntity[index].data!,

                                    ),
                                  ),
                                );
                              },
                            child: Container(
                              height: 40.h,
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              margin: EdgeInsets.symmetric(vertical: 5.h),
                              decoration: BoxDecoration(
                                color: ColorPalette.tGrey,
                                borderRadius: BorderRadius.circular(5.sp),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Row(
                                    children: [
                                      Icon(Icons.circle,size: 7.sp,),
                                      SizedBox(width: 18.w,),
                                      Text(statusSummarySuccess.wellsEntity[index].data!.wellName!,style: TextStyleP.f14Bold,),
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios),

                                ],
                              ),
                            ),
                          );
                        },);
                    }
                    else if(state.wellStatus is WellLoading){
                      return ShimmerClass.shimmerListviewVertical(height: 40);

                    }else if(state.wellStatus is WellError){
                      WellError wellError=state.wellStatus as WellError;
                      return Center(child: Text(wellError.error));

                    }else{
                      return Center(child: SizedBox());

                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


