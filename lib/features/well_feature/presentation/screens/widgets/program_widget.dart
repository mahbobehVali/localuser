import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/common/utils/constants.dart';
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
    return BlocBuilder<WellDetailBloc, WellDetailState>(builder: (context, state) {
      if(state.getProgramStatus is GetProgramSuccess){
        GetProgramSuccess getProgramSuccess=state.getProgramStatus as GetProgramSuccess;
        final displayDays = [
          getProgramSuccess.programDayEntity.last,
          ...getProgramSuccess.programDayEntity.sublist(0, getProgramSuccess.programDayEntity.length - 1),
        ];
        final maxRows = displayDays.map((e) => e.periods!.length).reduce((a, b) => a > b ? a : b);

        return Column(
          children: [
            Container(
              height: 70.h,
              padding: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconContainer(
                        icon: Icon(Icons.edit_calendar_outlined),
                        // icon: Image.asset("assets/icons/calender.png"),
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

            maxRows==0? Center(child: Text("برنامه ای وجود ندارد")):
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: displayDays.length * 150,
                child: Column(
                  children: [

                    Row(
                      children: displayDays.map((day) {
                        return _header(day.dayName!);
                      }).toList(),
                    ),
                    ListView.builder(
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
                                onTap: () {
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
      }else if(state.getProgramStatus is GetProgramLoading){
        return Center(child: CircularProgressIndicator(),);
      }else if(state.getProgramStatus is GetProgramError){
        GetProgramError getProgramError=state.getProgramStatus as GetProgramError;
        return Center(child: Text(getProgramError.error),);
      }else {
        return SizedBox();
      }
    },);
  }

  Widget _header(String title) {
    return Container(
      width: 150,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorPalette.inverseGrey,
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _cell(String text,int empty,int d) {
    return Container(
      width: 150,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        // color: Colors.red
      ),
      child: Container(
        decoration: empty==0?null:BoxDecoration(border: Border.all(width: 1)),
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
