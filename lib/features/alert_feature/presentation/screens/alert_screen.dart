import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/params/alert_filter_params.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_create_usecase.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_detail_usecase.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_usecase.dart';
import 'package:mahaliii/features/alert_feature/presentation/bloc/alert_status.dart';
import 'package:mahaliii/features/alert_feature/presentation/screens/alert_detail_screen.dart';
import 'package:mahaliii/features/alert_feature/presentation/screens/widgets/filter_widget.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/area_usecase.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/region_usecase.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/wells_list_usecase.dart';
import 'package:mahaliii/locator.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../common/widgets/account_box_title.dart';
import '../../../../common/widgets/export_to_excel.dart';
import '../../../../common/widgets/pagination_widget.dart';
import '../../domain/entity/alert_data_entity.dart';
import '../bloc/alert_bloc.dart';


class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<AlertBloc>(
    create: (context) {
    AlertBloc alertBloc=AlertBloc(
      locator<AlertUseCase>(),
      locator<RegionUseCase>(),
      locator<AreaUseCase>(),
      locator<WellsListUseCase>(),
      locator<AlertDetailUseCase>(),
      locator<AlertCreateUseCase>(),
    );
    alertBloc.add(AlertStart(alertFilterParams: AlertFilterParams(
       page: 1
    )));
    return alertBloc;
    },
  child: Padding(
          padding:  EdgeInsets.only(left: 16.w,right: 16.w,top: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( "هشدارها و اعلان‌ها",style: TextStyleP.f16Medium,),
              SizedBox(height: 16.h),
              Text("در این بخش تمامی هشدارهای ارسال شده از دستگاه را مشاهده میکنید.",style: TextStyleP.f12Regular),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<AlertBloc, AlertState>(
                    builder: (context, state) {
                      return AccountBoxTitle(title: "دانلود جدول",titleIcon: "assets/icons/edit.png",
                    divider: false,onTap:state.alertStatus is AlertEmpty?null: () {

                      if (state.alertStatus is AlertSuccess) {
                        final alertSuccess = state.alertStatus as AlertSuccess;
                        final allData = alertSuccess.alertsEntity.data!;

                        if (allData.isNotEmpty) exportToExcel(context,allData);
                      }
                    });
                      },
                    ),
                ],
              ),

              SizedBox(height: 24.h),
              Expanded(
                child: Container(
                  decoration: Constants().whiteFiveRadiusDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FilterWidget(),
                        SizedBox(height: 10,),

                        Expanded(
                          child: BlocBuilder<AlertBloc, AlertState>(
                            buildWhen: (previous, current) => current.alertStatus!=previous.alertStatus,
                            builder: (context, state) {
                              if(state.alertStatus is AlertSuccess){
                                AlertSuccess alertSuccess=state.alertStatus as AlertSuccess;

                                return (alertSuccess.alertsEntity.data?.isEmpty ?? true)?
                                Center(child: Text("هشداری وجود ندارد")):
                                Column(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: SizedBox(
                                          width: 500,

                                          child: ListView.builder(
                                            // physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero, // این خط فاصله اضافه را حذف می‌کند

                                            itemCount: alertSuccess.alertsEntity.data!.length+1,
                                            itemBuilder: (context, index) {
                                              List<AlertDataEntity> data=[];
                                              if(index>0) data=alertSuccess.alertsEntity.data!;

                                              return index==0? Container(
                                                padding: const EdgeInsets.all(12),

                                                decoration:  Constants().boxDecoration,
                                                child: Row(
                                                  children: [
                                                    Expanded(flex: 4,child: Text("نام چاه")),
                                                    Expanded(flex: 4,child: Text("نوع هشدار")),
                                                    Expanded(flex: 2,child: Text("ساعت")),
                                                    Expanded(flex: 3,child: Text("تاریخ")),
                                                    Expanded(flex: 4,child: Text("وضعیت")),
                                                  ],
                                                ),
                                              ):GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                    return AlertDetailScreen(alertDataEntity: data[index-1]);
                                                  },));
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(12),

                                                  decoration: BoxDecoration(
                                                    border: BoxBorder.fromLTRB(bottom: BorderSide(color: Color(0xffD7D7D7))),

                                                  ),child: Row(
                                                  children: [
                                                    Expanded(flex: 4,child: Text(data[index-1].wellName!)),

                                                    Expanded(flex: 4,child: Text(data[index-1].message!)),
                                                    Expanded(flex: 2,child: Text(data[index-1].clock!.toPersianDigit())),

                                                    Expanded(flex: 3,child: Text(data[index-1].date!.toPersianDigit())),
                                                    Expanded(flex: 4,child: Container(
                                                      padding: EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        color: data[index-1].status==0 ?ColorPalette.lightBlue:
                                                        data[index-1].status==1?Colors.yellow:
                                                        ColorPalette.lightGreen,
                                                        borderRadius: BorderRadius.circular(5)
                                                      ),
                                                      child: Text(data[index-1].status==0 ?"جدید":
                                                      data[index-1].status==1?"در حال بررسی":
                                                      "رفع شده",textAlign: TextAlign.center,),
                                                    )),

                                                  ],
                                                ),),
                                              );
                                            },),
                                        ),
                                      ),
                                    ),
                                    PaginationWidget(
                                      selected: state.selectedAlertPage ?? 1,
                                      lastPage: alertSuccess.alertsEntity.meta.lastPage!,
                                      onPageChanged: (newPage) {
                                        BlocProvider.of<AlertBloc>(context).add(
                                          AlertStart(
                                            alertFilterParams: AlertFilterParams(
                                              page: newPage,
                                              type: state.alertFilterModel!.filterType == true
                                                  ? state.selectedAlertType
                                                  : null,
                                              status: state.alertFilterModel!.filterStatus == true
                                                  ? state.selectedAlertStatus
                                                  : null,
                                              wellName: state.alertFilterModel!.filterWellName == true
                                                  ? state.wellName
                                                  : null,
                                              startDate: state.alertFilterModel!.filterDate == true
                                                  ? state.alertStartDate
                                                  : null,
                                              endDate: state.alertFilterModel!.filterDate == true
                                                  ? state.alertEndDate
                                                  : null,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                );
                              }
                              else if(state.alertStatus is AlertLoading){
                                return Center(child: CircularProgressIndicator());

                              }else if(state.alertStatus is AlertEmpty){
                                return SizedBox(
                                    height: 200,
                                    child: Center(child: Text("هشداری وجود ندارد")));

                              }else if(state.alertStatus is AlertError){
                                AlertError alertError=state.alertStatus as AlertError;
                                return Center(child:Text(alertError.error));

                              }else{
                                return SizedBox();
                              }

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ));
  }
}

