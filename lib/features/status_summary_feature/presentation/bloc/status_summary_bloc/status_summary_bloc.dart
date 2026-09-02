import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:mahaliii/common/utils/use_case.dart';
import 'package:mahaliii/features/status_summary_feature/domain/repository/status_summary_repository.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/last_activity_usecase.dart';
import 'package:mahaliii/features/status_summary_feature/presentation/bloc/status_summary_bloc/report_flowmeter_status.dart';
import 'package:mahaliii/features/status_summary_feature/presentation/bloc/status_summary_bloc/water_status.dart';

import '../../../../../common/params/flowmeter_params.dart';
import '../../../../../common/socket_repository.dart';
import '../../../../../common/utils/data_state.dart';
import '../../../domain/entity/last_activity_data_entity.dart';
import '../../../domain/usecase/report_flowmeter_usecase.dart';
import '../../../domain/usecase/wells_list_usecase.dart';
import 'last_activity_status.dart';
import 'status_summary_status.dart';

part 'status_summary_event.dart';
part 'status_summary_state.dart';

class StatusSummaryBloc extends Bloc<StatusSummaryEvent, StatusSummaryState> {
  WellsListUseCase wellsListUseCase;
  LastActivityUseCase lastActivityUseCase;
  final StatusSummaryRepository statusSummaryRepository;
  ReportFlowMeterUseCase reportFlowMeterUseCase;
  SocketRepository socketRepository;

  StatusSummaryBloc(this.wellsListUseCase,
      this.lastActivityUseCase,this.statusSummaryRepository,
      this.reportFlowMeterUseCase,this.socketRepository)
      : super(StatusSummaryState(statusSummaryStatus: StatusSummaryLoading(),
    lastActivityStatus: LastActivityLoading(),
    waterStatus: WaterLoading(),
    reportFlowMeterStatus: SummaryFlowMeterInitial(),
    selectedPage: 1,
    selectedChartTab: 0

  )) {
    on<WellsListStart>((event, emit) async {
      emit(state.copyWith(newStatusSummaryStatus: StatusSummaryLoading()));

      DataState dataState = await wellsListUseCase(NoParams());

      if (dataState is DataSuccess) {
          emit(state.copyWith(newStatusSummaryStatus: StatusSummarySuccess(dataState.data)));

      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          // locator<SharedPrefOperator>().logout(); // ۱. پاک کردن توکن
          emit(state.copyWith(newStatusSummaryStatus: StatusSummaryExit()));
        }else {
          emit(state.copyWith(newStatusSummaryStatus: StatusSummaryError(dataState.error!)));
        }
      }
    });

    on<ReportFlowMeter>((event, emit) async {
      if (state.reportFlowMeterStatus is SummaryFlowMeterLoading) return;

      emit(state.copyWith(newReportFlowMeterStatus: SummaryFlowMeterLoading(),
          newSelectedChartTab: event.flowMeterParams.type));
      DataState dataState = await reportFlowMeterUseCase(event.flowMeterParams);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newReportFlowMeterStatus:  SummaryFlowMeterSuccess(dataState.data)));

      }
      if (dataState is DataFailed) {
        emit(state.copyWith(
            newReportFlowMeterStatus: SummaryFlowMeterError(dataState.error!)));
      }});

    on<LastActivityStart>((event, emit) async {
      emit(state.copyWith(newLastActivityStatus: LastActivityLoading(),
          newSelectedPage: event.flowMeterParams.page));

      DataState dataState = await lastActivityUseCase(event.flowMeterParams);

      if (dataState is DataSuccess) {
        // 💡 با اضافه کردن ?. و ?? true امنیت کد را در برابر لایه نال تامین می‌کنیم
        final bool isAllEmpty = dataState.data.data.every(
                (LastActivityDataEntity element) => element.dates?.isEmpty ?? true
        );

        if (isAllEmpty) {
          emit(state.copyWith(newLastActivityStatus: LastActivityEmpty()));
        } else {
          emit(state.copyWith(newLastActivityStatus: LastActivitySuccess(dataState.data)));
        }
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newLastActivityStatus: LastActivityError(dataState.error!)));
      }
    });

    on<SocketEvent>((event, emit) async {
      print("socketStart");
      // اگر از قبل متصل هستیم و فقط می‌خواهیم دیتا بگیریم، لودینگ نشان ندهیم
      if (state.waterStatus is! WaterSuccess) {
        emit(state.copyWith(newWaterStatus: WaterLoading()));
      }

      // ۱. فرمان اتصال به ریپازیتوری
      socketRepository.requestWaterData(event.level, event.areaId);
      // socketRepository.connect(event.level, event.areaId);

      // ۲. مدیریت استریم با emit.forEach
      await emit.forEach<dynamic>(
        socketRepository.waterStream,
        onData: (waterModel) {
          return state.copyWith(
            newWaterStatus: WaterSuccess(waterData: waterModel),
          );
        },
        onError: (error, stackTrace) {
          print(" BLoC Stream Error: $error");
          return state.copyWith(
            newWaterStatus: WaterError(error.toString()),
          );
        },
      );
    }
    );
  }

  //  این بخش حیاتی برای "خروج از صفحه" است
  @override
  Future<void> close() {
    socketRepository.dispose(); // قطع سوکت دقیقا هنگام خروج از صفحه
    return super.close();
  }

}
