import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/widgets/show_dialogs.dart';
import '../../../../../config/color_palette.dart';
import '../../bloc/alert_bloc.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlertBloc, AlertState>(
        builder: (context, state) {

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  ShowDialogs().alertFilter(context, BlocProvider.of<AlertBloc>(context));
                },
                child: Container(
                  width: MediaQuery.sizeOf(context).width*0.2,
                  padding: const EdgeInsets.all(8.0),

                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ColorPalette.backColor
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.filter_alt_outlined,size: 20,),
                      SizedBox(width: 5,),
                      Text("فیلتر"),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (state.alertFilterModel?.filterType==true )
                        FilterChipWidget(label:"${state.alertFilterModel!.type}",onDeleted:
                            () {
                          BlocProvider.of<AlertBloc>(context).add(RemoveSingleFilterEvent(
                              state.alertFilterModel!.copyWith(
                                  newFilterType: false,
                                  newType: null
                              )));

                        }
                        ),
                      if (state.alertFilterModel?.filterDate==true )
                        FilterChipWidget(label:"${state.alertFilterModel!.startDate}-${state.alertFilterModel!.endDate}",onDeleted:
                          () {
                          BlocProvider.of<AlertBloc>(context).add(RemoveSingleFilterEvent(
                          state.alertFilterModel!.copyWith(
                          newFilterDate: false,
                          newEndDate: null,
                          newStartDate: null
                          )));
                        }
                        ),

                      if (state.alertFilterModel?.filterStatus==true )
                        FilterChipWidget(label:"${state.alertFilterModel!.status}",onDeleted:
                            () {
                              BlocProvider.of<AlertBloc>(context).add(RemoveSingleFilterEvent(
                                  state.alertFilterModel!.copyWith(
                                      newFilterStatus: false,
                                      newStatus: null
                                  )));

                        }
                        ),

                      if (state.alertFilterModel?.filterWellName==true)
                        FilterChipWidget(label:"${state.alertFilterModel!.wellName}",onDeleted:
                            () {
                              BlocProvider.of<AlertBloc>(context).add(RemoveSingleFilterEvent(
                                  state.alertFilterModel!.copyWith(
                                      newFilterWellName: false,
                                      newWellName: null
                                  )));
                        }
                        ),
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Chip(
        backgroundColor: Colors.white,
        label: Text(label),
        onDeleted: onDeleted,
      ),
    );
  }
}