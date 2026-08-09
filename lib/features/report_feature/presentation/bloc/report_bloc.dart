import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/utils/use_case.dart';
import 'package:mahaliii/features/report_feature/domain/usecase/get_capacity_usecase.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/report_command_status.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/report_count_status.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/report_flow_meter_status.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/user_activity_report_status.dart';
import 'package:mahaliii/features/report_feature/presentation/bloc/well_report_status.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/last_activity_usecase.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/wells_list_usecase.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/well_work_usecase.dart';

import '../../../../common/utils/constants.dart';
import '../../../../common/utils/data_state.dart';
import '../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../../../status_summary_feature/domain/entity/last_activity_data_entity.dart';
import '../../../well_feature/domain/usecase/alert_count_usecase.dart';
import '../../../well_feature/domain/usecase/flow_meter_usecase.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  WellsListUseCase wellsListUseCase;
  AlertCountUseCase alertCountUseCase;
  WellFlowMeterUseCase wellFlowMeterUseCase;
  GetCapacityUseCase getCapacityUseCase;
  WellWorkHourUseCase wellWorkHourUseCase;
  LastActivityUseCase lastActivityUseCase;
  ReportBloc(this.wellsListUseCase,this.alertCountUseCase,
      this.wellFlowMeterUseCase,this.getCapacityUseCase,
      this.wellWorkHourUseCase,this.lastActivityUseCase) : super(ReportState(
    wellReportStatus: WellReportInitial(),
  wells: [],
    oneWell: [],
    startDate: "",
    startHour: "00:00",
    endDate: "",
    endHour: "23:59",
    reportCountStatus: ReportCountInitial(),
    reportFlowMeterStatus:  ReportFlowMeterInitial(),
    reportCommandStatus: ReportCommandInitial(),
    reportIndexList: Constants().reportIndex,
    selectedReportIndex: 0,
    flowMeterParams: FlowMeterParams(),
    userActivityReportStatus: UserActivityReportInitial(),
    selectedLastActivityPage: 1,
  )) {
    on<StartReport>((event, emit) async {
      emit(state.copyWith(newWellReportStatus: WellReportLoading()));
      DataState dataState = await wellsListUseCase(NoParams());

      if (dataState is DataSuccess) {
        emit(state.copyWith(newWellReportStatus: WellReportSuccess(dataState.data)));
      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          // locator<SharedPrefOperator>().logout(); // ۱. پاک کردن توکن
          emit(state.copyWith(newWellReportStatus: WellReportExit()));
        }else {
          emit(state.copyWith(
              newWellReportStatus: WellReportError(dataState.error!)));
        }      }
    });

    on<WellSelected>((event, emit) async {
      emit(state.copyWith(newOneWell: event.wellsDataEntity));

    });

    on<ChangeDate>((event, emit) async {
      emit(state.copyWith(newStartDate: event.startDate,newEndDate: event.endDate));

    });

    on<ChangeStartClock>((event, emit) async {
      emit(state.copyWith(newStartHour: event.startHour));

    });
    on<ChangeEndClock>((event, emit) async {
      emit(state.copyWith(newEndHour: event.endHour));

    });

    on<GetAlertCount>((event, emit) async {
      emit(state.copyWith(newReportCountStatus: ReportCountLoading()));
      DataState dataState = await alertCountUseCase(event.flowMeterParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newReportCountStatus: ReportCountSuccess(dataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newReportCountStatus: ReportCountError(dataState.error!)));
      }
    });

    on<ReportFlowMeter>((event, emit) async {

      final bool ignoreAllWell = state.selectedReportIndex == 0;
      emit(state.copyWith(newReportFlowMeterStatus: ReportFlowMeterLoading(),
                          newFlowMeterParams: event.flowMeterParams));
      DataState dataState = await wellFlowMeterUseCase(event.flowMeterParams,
          ignoreAllWell: ignoreAllWell);
      DataState capacityDataState = await getCapacityUseCase(event.flowMeterParams);

      if (dataState is DataSuccess) {

        emit(state.copyWith(newReportFlowMeterStatus: ReportFlowMeterSuccess(
            dataState.data,capacityDataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newReportFlowMeterStatus: ReportFlowMeterError(dataState.error??"حطایی رخ داده")));
      }
    });

    on<ReportCommand>((event, emit) async {
      emit(state.copyWith(newReportCommandStatus: ReportCommandLoading()));
      DataState dataState = await wellWorkHourUseCase(event.flowMeterParams);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newReportCommandStatus: ReportCommandSuccess(dataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newReportCommandStatus: ReportCommandError(dataState.error!)));
      }
    });

    on<UserActivityReportStart>((event, emit) async {
      emit(state.copyWith(newUserActivityReportStatus: UserActivityReportLoading(),
          newSelectedLastActivityPage: event.flowMeterParams.page,
      newFlowMeterParams: event.flowMeterParams));

      DataState dataState = await lastActivityUseCase(event.flowMeterParams);

      if (dataState is DataSuccess) {
        // 💡 با اضافه کردن ?. و ?? true امنیت کد را در برابر لایه نال تامین می‌کنیم
        final bool isAllEmpty = dataState.data.data.every(
                (LastActivityDataEntity element) => element.dates?.isEmpty ?? true
        );

        if (isAllEmpty) {
          emit(state.copyWith(newUserActivityReportStatus: UserActivityReportEmpty()));
        } else {
          emit(state.copyWith(newUserActivityReportStatus: UserActivityReportSuccess(dataState.data)));
        }
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newUserActivityReportStatus: UserActivityReportError(dataState.error!)));
      }
    });

    on<OneReportIndexClicked>((event, emit) async {
      emit(state.copyWith(newSelectedReportIndex: event.alertTypeEntity.id));
      if(event.alertTypeEntity.id==0 || event.alertTypeEntity.id==1) {
        add(ReportFlowMeter(state.flowMeterParams!));
      }
    //   switch (event.alertTypeEntity.id) {
    //     case 0:
    //       add(ReportFlowMeter(state.flowMeterParams!));
    //     case 1:
    //       add(ReportFlowMeter(state.flowMeterParams!));
    //       break;
    //     case 2:
    //       add(ReportCommand(state.flowMeterParams!));
    //       break;
    //     case 3:
    //      add(GetAlertCount(state.flowMeterParams!));
    //       break;
    //     case 4:
    //       add(UserActivityReportStart(state.flowMeterParams!));
    //       break;
    // }
    });

    on<SearchClicked>((event, emit) async {
      // emit(state.copyWith(newFlowMeterParams: event.flowMeterParams));
      add(OneReportIndexClicked(AlertTypeEntity("",0)));
    });

  }
}
