import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/common/widgets/global_snackbar.dart';
import 'package:mahaliii/common/widgets/shimmer_class.dart';
import 'package:mahaliii/config/texts_style.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../common/widgets/global_elevated_button.dart';
import '../../../../../common/widgets/icon_container.dart';
import '../../../../../common/widgets/show_dialogs.dart';
import '../../../../../config/color_palette.dart';
import '../../../../status_summary_feature/domain/entity/wells_data_entity.dart';
import '../../bloc/well_detail_bloc/get_program_status.dart';
import '../../bloc/well_detail_bloc/well_detail_bloc.dart';

class Program extends StatelessWidget {
   const Program({super.key,required this.wellsDataEntity});
  final WellsDataEntity wellsDataEntity;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<WellDetailBloc, WellDetailState>(builder: (context, state) {
          if(state.getProgramStatus is GetProgramSuccess){
            GetProgramSuccess getProgramSuccess=state.getProgramStatus as GetProgramSuccess;
            final displayDays = [
              getProgramSuccess.programDayEntity.last,
              ...getProgramSuccess.programDayEntity.sublist(0, getProgramSuccess.programDayEntity.length - 1),
            ];
            final maxRows = displayDays.map((e) => e.periods!.length).reduce((a, b) => a > b ? a : b);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 70.h,
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: ColorPalette.white,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconContainer(
                            icon: Icon(Icons.edit_calendar_outlined),
                            color: ColorPalette.iconContainerColor,
                            width: 24,
                            height: 24,
                          ),
                          SizedBox(width: 6.w),

                          Text("برنامه‌ریزی هفتگی پمپ"),
                        ],
                      ),
                      SizedBox(width: 8),
                      Builder(
                        builder: (context) {
                          return GlobalElevatedButton(
                            borderRadius: 2.5,
                            widget: Text(
                              "ثبت زمان جدید",
                              style: TextStyle(color: Colors.black),
                            ),
                            backColor: ColorPalette.darkBlue,
                            onTap: () {
                              ShowDialogs().newTimeCreate(
                                context: context,
                                wellDetailBloc: BlocProvider.of<WellDetailBloc>(context,),
                                wellsDataEntity: wellsDataEntity,
                                programDayEntity: getProgramSuccess.programDayEntity

                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),

                maxRows==0? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Container(

                    width:490,
                    decoration: BoxDecoration(
                      color: ColorPalette.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Column(
                      children: [
                        Row(
                          children: Constants().weekDayNames.map((day) {
                            return _header(day.name,width: 70);
                          }).toList(),
                        ),
                        // SizedBox(height: 20.h,),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text("برنامه ای وجود ندارد"),
                        ),
                      ],
                    )),
                  ),
                ):
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width:1100,
                    decoration: BoxDecoration(
                    color: ColorPalette.white,
                    borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("جدول برنامه ریزی هفتگی دستگاه",
                          style: TextStyleP.f14Medium.copyWith(color: Colors.black),),
                        SizedBox(height: 12.h,),
                        Row(
                          children: displayDays.map((day) {
                            return _header(day.dayName!);
                          }).toList(),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: maxRows,
                          itemBuilder: (context, row) {
                            return Row(
                              children: List.generate(displayDays.length, (col) {
                                final day = displayDays[col];

                                if (row >= day.periods!.length) {
                                  return _cell("-",0,0);
                                }

                                final p = day.periods![row];
                               int d= Constants().weekDayNames.firstWhere((element) => element.name==day.dayName,
                                   orElse: () => state.daySelected).id;


                                return GestureDetector(
                                    onTap:p.own==0?() {
                                      ShowDialogs().customDialog(context);
                                    }: () {
                                      ShowDialogs().deleteClock(context: context,wellDetailBloc: BlocProvider.of<WellDetailBloc>(context),
                                          wellsDataEntity:wellsDataEntity,startTime:p.startTime.toString().toPersianDigit(),
                                         endTime: p.endTime.toString().toPersianDigit(),
                                          dayName: day.dayName!,userLocalId: p.userLocalID!,day: d );
                                    },
                                  child: _cell(
                                      "${p.endTime.toString().toPersianDigit()} _ ${p.startTime.toString().toPersianDigit()}",
                                     1,d
                                  ),
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          else if(state.getProgramStatus is GetProgramLoading){
            return ShimmerClass.shimmerTable();
          }else if(state.getProgramStatus is GetProgramError){
            GetProgramError getProgramError=state.getProgramStatus as GetProgramError;
            return Center(child: Text(getProgramError.error),);
          }else {
            return SizedBox();
          }
        },),
      ],
    );
  }

  Widget _header(String title, {double width = 150}) {
    return Container(
      width: width,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorPalette.lightGrey,
        
      ),
      child: Text(
        title,
        style: TextStyleP.f12Regular,
      ),
    );
  }

  Widget _cell(String text,int empty,int d) {
    return Container(
      width: 150,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: BoxBorder.fromLTRB(bottom: BorderSide( color: ColorPalette.lightGrey))
        // color: Colors.red
      ),
      child: Container(
        decoration: empty==0?null:BoxDecoration(
            border: Border.all(color: ColorPalette.mediumGrey),
            borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
