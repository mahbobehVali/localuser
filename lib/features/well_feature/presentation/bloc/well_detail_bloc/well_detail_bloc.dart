import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mahaliii/common/params/create_time_params.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/socket_repository.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_type_entity.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/flow_meter_usecase.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/get_program_usecase.dart';
import 'package:mahaliii/features/well_feature/domain/usecase/well_work_usecase.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/delete_time_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/pump_performance_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/week_well_work_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/well_screen_status.dart';
import 'package:mahaliii/features/well_feature/presentation/bloc/well_detail_bloc/well_status.dart';
import '../../../../../common/utils/data_state.dart';
import '../../../../../common/utils/use_case.dart';
import '../../../../status_summary_feature/domain/usecase/wells_list_usecase.dart';
import '../../../domain/repository/wells_repository.dart';
import '../../../domain/usecase/alert_count_usecase.dart';
import 'alert_count_status.dart';
import 'create_time_status.dart';
import 'finger_status.dart';
import 'get_program_status.dart';
import 'on_off_status.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';


part 'well_detail_event.dart';
part 'well_detail_state.dart';

class WellDetailBloc extends Bloc<WellDetailEvent, WellDetailState> {
  final WellsRepository wellsRepository;
  final WellWorkHourUseCase wellWorkUseCase;
  final WellFlowMeterUseCase wellFlowMeterUseCase;
  WellsListUseCase wellsListUseCase;
  GetProgramUseCase getProgramUseCase;
  SocketRepository socketRepository;
  AlertCountUseCase alertCountUseCase;

  WellDetailBloc(this.wellsRepository,this.wellWorkUseCase,
      this.wellFlowMeterUseCase,this.wellsListUseCase,
      this.getProgramUseCase,this.socketRepository,this.alertCountUseCase) : super(WellDetailState(
      fingerStatus: FingerInitial(),
      status: 1,
      wellStatus: WellLoading(),
      isSwitched: false,
    daySelected: AlertTypeEntity("", -1),
    wellWorkStatus: WeekWellWorkInitial(),
    wellPerformanceStatus: WellPerformanceLoading(),
    alertCountStatus: AlertCountLoading(),
    getProgramStatus: GetProgramLoading(),
    selectedWellTab: 0,
    startHour: "",
    endHour: "",
    createTimeStatus: CreateTimeInitial(),
    onOffStatus: OnOffInitial(),
    deleteTimeStatus: DeleteTimeInitial(),
    selectedChartTab: 0,
    wellScreenStatus: WellScreenInitial(),
    userLocalId: null
  )) {
    on<WellStart>((event, emit) async {
      emit(state.copyWith(newWellStatus: WellLoading()));

      DataState dataState = await wellsListUseCase(NoParams());

      if (dataState is DataSuccess) {
        emit(state.copyWith(newWellStatus: WellSuccess(dataState.data)));

      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newWellStatus: WellError(dataState.error!)));
      }
    });
    on<FingerSocketEvent>(
          (event, emit) async {
        // ۱. حتماً ابتدا استیت لودینگ را منتشر کنید
            print("1. BEFORE EMIT: ${state.fingerStatus}");
            emit(state.copyWith(newFingerStatus: FingerLoading()));
            print("2. AFTER EMIT: ${state.fingerStatus}");
        // ۲. ارسال درخواست سوکت
        socketRepository.requestFinger(event.deviceId, event.pin);

        // ۳. گوش دادن به استریم سوکت
        await emit.forEach<dynamic>(
          socketRepository.dashboardStatusCheckFinger,
          onData: (response) {
            if (response.source == FingerprintSource.requestResponse) {
              if (response.status == 1) {
                print("FingerRequestAccepted");
                return state.copyWith(
                  newFingerStatus: FingerRequestAccepted(response.status),
                );
              } else {
                print("FingerRequestFailed");
                return state.copyWith(
                  newFingerStatus: FingerRequestFailed("عدم پاسخ از طرف دستگاه"),
                );
              }
            } else if (response.source == FingerprintSource.statusListener) {
              if (response.status == 1 || response.status == "1") {
                print("FingerSuccess");
                return state.copyWith(
                  newFingerStatus: FingerSuccess(
                    status: response.status,
                    userLocalID: response.userLocalID,
                  ),
                  newUserLocalId: response.userLocalID,
                );
              } else {
                return state.copyWith(
                  newFingerStatus: FingerError("عدم موفقیت در ثبت اثر انگشت"),
                );
              }
            } else {
              return state.copyWith(
                newFingerStatus: FingerError("نامشخص"),
              );
            }
          },
          onError: (error, stackTrace) {
            return state.copyWith(
              newFingerStatus: FingerError(error.toString()),
            );
          },
        );
      },
      transformer: restartable(), // 👈 حتما اضافه شود تا استریم‌های قبلی کنسل شوند
    );

    on<StatusEvent>((event, emit) {
      if (event.status == 0) {
        emit(state.copyWith(
          newFingerStatus: FingerError("پاسخی از سمت دستگاه دریافت نشد."),
        ));
      }
    });

    // on<StatusEvent>((event, emit) async {
    //   emit(state.copyWith(newStatus: event.status));
    //
    // });
    on<FirstSwitch>((event, emit) async {
      emit(state.copyWith(newIsSwitched: event.isSwitch));

    });

    on<SwitchClicked>((event, emit) async {
      // اگر از قبل متصل هستیم و فقط می‌خواهیم دیتا بگیریم، لودینگ نشان ندهیم
      // if (state.onOffStatus is! OnOffSuccess) {
      //   emit(state.copyWith(newOnOffStatus: OnOffSuccess()));
      // }
      // ارسال درخواست مخصوص این صفحه
      emit(state.copyWith(newOnOffStatus: OnOffLoading()));

      socketRepository.onAndOff(event.createTimeParams);

      // ۲. مدیریت استریم با emit.forEach
      await emit.forEach<dynamic>(
        // socketRepository.onAndOffTimeStream,
        socketRepository.onAndOffTimeStream.timeout(
          const Duration(seconds: 60),
          onTimeout: (sink) {
            // زمانی که ۶۰ ثانیه بگذرد و هیچ دیتایی نیاید، این بخش اجرا می‌شود
            sink.addError("زمان پاسخگویی پمپ به پایان رسید (Timeout)");
          },
        ).take(1),
        onData: (onOff) {
          print("onOff$onOff");
          // دیتای دریافتی را به وضعیت موفقیت می‌بریم
          return state.copyWith(
            newIsSwitched: onOff==1?true:false,
            newOnOffStatus: OnOffSuccess(onOff)
          );
        },
          onError: (error, stackTrace) {
          print("❌ BLoC Stream Error: $error");
          return state.copyWith(
            newOnOffStatus: OnOffError(error.toString()),
          );
        },
      );

    });
    // در فایل well_detail_bloc.dart
    on<ResetOnOffStatus>((event, emit) {
      // مقدار استاتوس را دوباره به حالت اولیه (یا موفقیت قبلی/خالی) برمی‌گردانیم
      emit(state.copyWith(newOnOffStatus: OnOffInitial()));
    });

    on<ResetCreateTimeStatus>((event, emit) {
      // مقدار استاتوس را دوباره به حالت اولیه (یا موفقیت قبلی/خالی) برمی‌گردانیم
      emit(state.copyWith(newCreateTimeStatus: CreateTimeInitial()));
    });
    on<ResetDeleteStatus>((event, emit) {
      // مقدار استاتوس را دوباره به حالت اولیه (یا موفقیت قبلی/خالی) برمی‌گردانیم
      emit(state.copyWith(newDeleteTimeStatus: DeleteTimeInitial()));
    });


    on<DayClicked>((event, emit) async {
      emit(state.copyWith(newDaySelected: event.alertTypeEntity));

    });

    on<WellWorkHourStart>((event, emit) async {
      emit(state.copyWith(newWeekWellWorkStatus: WeekWellWorkLoading(),
          newSelectedChartTab: event.flowMeterParams.type));
      if(event.flowMeterParams.type==0){
        DataState todayDataState = await wellWorkUseCase(event.flowMeterParams);

        if (todayDataState is DataSuccess) {

          emit(state.copyWith(newWeekWellWorkStatus: WeekWellWorkSuccess(
              currentWellWorkEntity: todayDataState.data)));

        }
        if (todayDataState is DataFailed ) {
          emit(state.copyWith(newWeekWellWorkStatus: WeekWellWorkError(todayDataState.error??"")));
        }
      }

      if(event.flowMeterParams.type==2){
        DataState currentDataState = await wellWorkUseCase(event.flowMeterParams);
        DataState previousDataState = await wellWorkUseCase(FlowMeterParams(
            ids: event.flowMeterParams.ids,
            type: (event.flowMeterParams.type)!+1));

        if (previousDataState is DataSuccess && currentDataState is DataSuccess) {

          emit(state.copyWith(newWeekWellWorkStatus: WeekWellWorkSuccess(
              currentWellWorkEntity: currentDataState.data,
              previousWellWorkEntity: previousDataState.data)));

        }
        if (previousDataState is DataFailed && currentDataState is DataFailed ) {
          emit(state.copyWith(newWeekWellWorkStatus: WeekWellWorkError(currentDataState.error??"")));
        }
      }
    });


    on<WellPerformance>((event, emit) async {
      emit(state.copyWith(newWellPerformanceStatus: WellPerformanceLoading()));


      DataState currentDataState = await wellWorkUseCase(event.flowMeterParams);
      DataState flowMeterDataState = await wellFlowMeterUseCase(FlowMeterParams(
          ids: event.flowMeterParams.ids,
          type: (event.flowMeterParams.type)!+4));
      DataState alertDataState = await alertCountUseCase(event.flowMeterParams);

      if (flowMeterDataState is DataSuccess && currentDataState is DataSuccess
          && alertDataState is DataSuccess) {

        emit(state.copyWith(newWellPerformanceStatus: WellPerformanceSuccess(
          currentWellWorkEntity: currentDataState.data,
          wellFlowMeterEntity: flowMeterDataState.data,
          alertCountEntity: alertDataState.data
            )));

      }
      if (flowMeterDataState is DataFailed || currentDataState is DataFailed
          || alertDataState is DataFailed) {
        emit(state.copyWith(newWellPerformanceStatus: WellPerformanceError("خطایی رخ داده")));
      }
    });

    // on<AlertCount>((event, emit) async {
    //   emit(state.copyWith(newAlertCountStatus: AlertCountLoading()));
    //
    //
    //   DataState dataState = await alertCountUseCase(event.flowMeterParams);
    //
    //
    //
    //   if (dataState is DataSuccess) {
    //
    //     emit(state.copyWith(newAlertCountStatus: AlertCountSuccess(dataState.data)));
    //
    //   }
    //   if (dataState is DataFailed ) {
    //     emit(state.copyWith(newAlertCountStatus: AlertCountError(dataState.error??"")));
    //   }
    // });


    on<GetProgram>((event, emit) async {
      emit(state.copyWith(newGetProgramStatus: GetProgramLoading()));

      DataState getProgram = await getProgramUseCase(event.id);


      if (getProgram is DataSuccess ) {

        emit(state.copyWith(newGetProgramStatus:
        GetProgramSuccess(programDayEntity: getProgram.data)));

      }
      if (getProgram is DataFailed ) {
        emit(state.copyWith(newGetProgramStatus: GetProgramError(getProgram.error!)));
      }
    });

    on<ChangeWellTab>((event, emit) async {
      emit(state.copyWith(newSelectedWellTab: event.selectedTabIndex));

    });

    on<ChangeUserLocalId>((event, emit) async {
      emit(state.copyWith(newUserLocalId: event.userLocalId));

    });

    on<ChangeStartClock>((event, emit) async {
      emit(state.copyWith(newStartHour: event.startHour));

    });
    on<ChangeEndClock>((event, emit) async {
      emit(state.copyWith(newEndHour: event.endHour));

    });

    on<CreateNewTime>((event, emit) async {
      emit(state.copyWith(
        newCreateTimeStatus: CreateTimeLoading(),
      ));

      // ارسال درخواست مخصوص این صفحه
      socketRepository.requestCreateTimeData(event.createTimeParams);

      // ۲. مدیریت استریم با emit.forEach
      await emit.forEach<dynamic>(
        socketRepository.createTimeStream.timeout(
          const Duration(seconds: 60),
          onTimeout: (sink) {
            // زمانی که ۶۰ ثانیه بگذرد و هیچ دیتایی نیاید، این بخش اجرا می‌شود
            sink.addError("زمان پاسخگویی پمپ به پایان رسید (Timeout)");
          },
        ).take(1),
        onData: (status) {
          add(GetProgram(event.createTimeParams.deviceID!));
          // دیتای دریافتی را به وضعیت موفقیت می‌بریم
          return state.copyWith(
            newCreateTimeStatus: CreateTimeSuccess(status),
          );
        },
        onError: (error, stackTrace) {
          print("❌ BLoC Stream Error: $error");
          return state.copyWith(
            newCreateTimeStatus: CreateTimeError(error.toString()),
          );
        },
      );
    }
    );

    on<DeleteTime>((event, emit) async {
      emit(state.copyWith(newDeleteTimeStatus: DeleteTimeLoading()));

      // ارسال درخواست مخصوص این صفحه
     await socketRepository.requestDeleteTimeData(event.createTimeParams);

      // ۲. مدیریت استریم با emit.forEach
      await emit.forEach<dynamic>(
        socketRepository.deleteTimeStream.timeout(
          const Duration(seconds: 60),
          onTimeout: (sink) {
            // زمانی که ۶۰ ثانیه بگذرد و هیچ دیتایی نیاید، این بخش اجرا می‌شود
            sink.addError("زمان پاسخگویی پمپ به پایان رسید (Timeout)");
          },
        ).take(1),
        onData: (status) {
          add(GetProgram(event.createTimeParams.deviceID!));
          print(status);
          // دیتای دریافتی را به وضعیت موفقیت می‌بریم
          return state.copyWith(
            newDeleteTimeStatus: DeleteTimeSuccess(status),
          );
        },
        onError: (error, stackTrace) {
          print("❌ BLoC Stream Error: $error");
          return state.copyWith(
            newDeleteTimeStatus: DeleteTimeError(error.toString()),
          );
        },
      );
    }
    );

  }
  @override
  Future<void> close() {
    socketRepository.dispose(); // قطع سوکت دقیقا هنگام خروج از صفحه
    return super.close();
  }

}
