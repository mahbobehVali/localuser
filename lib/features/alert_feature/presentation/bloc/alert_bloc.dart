
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mahaliii/common/params/alert_filter_params.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_filter_model.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_type_entity.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_create_usecase.dart';
import 'package:mahaliii/features/alert_feature/domain/usecase/alert_detail_usecase.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/area_usecase.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/region_usecase.dart';
import 'package:mahaliii/features/status_summary_feature/domain/usecase/wells_list_usecase.dart';

import '../../../../common/params/send_new_request_to_support_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../../../status_summary_feature/domain/entity/wells_entity.dart';
import '../../domain/usecase/alert_usecase.dart';
import 'alert_create_status.dart';
import 'alert_detail_status.dart';
import 'alert_status.dart';
import 'alert_well_list_status.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertUseCase alertUseCase;
  RegionUseCase regionUseCase;
  AreaUseCase areaUseCase;
  WellsListUseCase wellsListUseCase;
  AlertDetailUseCase alertDetailUseCase;
  AlertCreateUseCase alertCreateUseCase;
  AlertBloc(this.alertUseCase,this.regionUseCase,this.areaUseCase,this.wellsListUseCase,
      this.alertDetailUseCase,this.alertCreateUseCase) : super(AlertState(
      alertStatus: AlertLoading(),selectedAlertPage: 1,
    wellName: "",
    date: "",
    alertWellListStatus: AlertWellListInitial(),
    oneWell: null,
    alertTypeList: Constants().alertType,
    selectedAlertType: 0,
    alertStatusList: Constants().alertStatus,
    selectedAlertStatus: 0,
    alertStartDate: "",
    alertEndDate: "",
    alertFilterModel: AlertFilterModel(),
    alertDetailStatus: AlertDetailInitial(),
    alertCreateStatus: AlertCreateInitial(),
    alert: null

  )) {
    on<AlertStart>((event, emit) async {

      emit(state.copyWith(newAlertStatus: AlertLoading(),
          newSelectedAlertPage:event.filter==true?1: event.alertFilterParams.page));
      DataState dataState = await alertUseCase(event.alertFilterParams);
      if (dataState is DataSuccess) {
        if(dataState.data.data.isEmpty){
          emit(state.copyWith(newAlertStatus: AlertEmpty()));
        }else{
          emit(state.copyWith(newAlertStatus: AlertSuccess(dataState.data)));
        }
      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          emit(state.copyWith(newAlertStatus: AlertExit()));
        }else {
          emit(state.copyWith(newAlertStatus: AlertError(dataState.error!)));
        }      }
    });

    on<AlertWellList>((event, emit) async {
      emit(state.copyWith(newAlertWellListStatus: AlertWellListLoading()));

      DataState dataState = await wellsListUseCase(NoParams());

      if (dataState is DataSuccess) {
        emit(state.copyWith(newAlertWellListStatus: AlertWellListSuccess(dataState.data)));

      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          // locator<SharedPrefOperator>().logout(); // ۱. پاک کردن توکن
          emit(state.copyWith(newAlertWellListStatus: AlertWellListExit()));
        }else {
          emit(state.copyWith(newAlertWellListStatus: AlertWellListError(dataState.error!)));
        }
      }
    });

    on<OneWellClicked>((event, emit) async {
      emit(state.copyWith(newOneWell: event.wellsEntity,
          newAlertFilterModel: event.alertFilterModel));

    });

    on<OneAlertTypeClicked>((event, emit) async {
      emit(state.copyWith(newSelectedAlertType: event.alertTypeEntity.id,
          newAlertFilterModel: event.alertFilterModel));

    });
    on<RemoveSingleFilterEvent>((event, emit) async {
      emit(state.copyWith(newAlertFilterModel: event.filter));
      add(AlertStart(filter: true,alertFilterParams: AlertFilterParams(
          type: event.filter.filterType==true? state.selectedAlertType :null,
          status: event.filter.filterStatus==true? state.selectedAlertStatus :null,
          wellName: event.filter.filterWellName==true? state.oneWell!.data!.wellName : null
      )));

    });

    on<OneAlertStatusClicked>((event, emit) async {
      emit(state.copyWith(newSelectedAlertStatus: event.alertStatusEntity.id,
          newAlertFilterModel: event.alertFilterModel));

    });

    on<AlertChangeDate>((event, emit) async {
      emit(state.copyWith(newAlertStartDate: event.startDate,newAlertEndDate: event.endDate,
          newAlertFilterModel: event.alertFilterModel));

    });

    on<AlertDetailEvent>((event, emit) async {

      emit(state.copyWith(newAlertDetailStatus: AlertDetailLoading(),newAlert: event.status));
      DataState dataState = await alertDetailUseCase(event.id);
      if (dataState is DataSuccess) {
        if(dataState.data.isEmpty){
          emit(state.copyWith(newAlertDetailStatus: AlertDetailEmpty()));
        }else{
          emit(state.copyWith(newAlertDetailStatus: AlertDetailSuccess(dataState.data)));
        }
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newAlertDetailStatus: AlertDetailError(dataState.error!)));
      }
    });

    on<AlertCreateEvent>((event, emit) async {
      print("bloc");

      emit(state.copyWith(newAlertCreateStatus: AlertCreateLoading()));

      DataState dataState = await alertCreateUseCase(event.sendNewSupportParams);

      if (dataState is DataSuccess) {
        // چک کردن نال نبودن برای جلوگیری از کرش
        final detailId = event.sendNewSupportParams.id;

        if (detailId != null) {
          // مستقیم UseCase دوم را اجرا می‌کنیم
          DataState detailDataState = await alertDetailUseCase(detailId);

          if (detailDataState is DataSuccess) {
            emit(state.copyWith(
              newAlertCreateStatus: AlertCreateSuccess(),
              newAlertDetailStatus: AlertDetailSuccess(detailDataState.data),
            ));
          } else {
            // مدیریت خطای جزئیات
            emit(state.copyWith(
              newAlertCreateStatus: AlertCreateSuccess(),
              newAlertDetailStatus: AlertDetailError(detailDataState.error!),
            ));
          }
        } else {
          emit(state.copyWith(newAlertCreateStatus: AlertCreateSuccess()));
        }
      }

      if (dataState is DataFailed) {
        emit(state.copyWith(newAlertCreateStatus: AlertCreateError(dataState.error!)));
      }
    });

    on<ChangeAlert>((event, emit) async {

      emit(state.copyWith(newAlert: event.status));

    });
  }
}
