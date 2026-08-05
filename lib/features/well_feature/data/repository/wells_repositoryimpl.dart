import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mahaliii/features/well_feature/data/model/alert_count_model.dart';
import 'package:mahaliii/features/well_feature/data/model/well_flowmeter_model.dart';
import 'package:mahaliii/features/well_feature/data/model/well_work_model.dart';
import 'package:mahaliii/features/well_feature/domain/entity/alert_count_entity.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_flowmeter_entity.dart';
import 'package:mahaliii/features/well_feature/domain/entity/well_work_entity.dart';

import '../../../../common/error_handling/check_exceptions.dart';
import '../../../../common/error_handling/exceptions.dart';
import '../../../../common/params/flowmeter_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/sharedpreference.dart';
import '../../../../locator.dart';
import '../../domain/entity/program_day_entity.dart';
import '../../domain/entity/program_entity.dart';
import '../../domain/repository/wells_repository.dart';
import '../datasource/remote/wells_api_provider.dart';

class WellsRepositoryImpl extends WellsRepository {
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);
  WellsApiProvider wellsApiProvider;

  WellsRepositoryImpl(this.wellsApiProvider);

  Future<dynamic> getToken() async {
    final userToken = locator<SharedPrefOperator>().getUserToken();
    return userToken;
  }

  @override
  Future<DataState> wellWorkHour(FlowMeterParams flowMeterParams) async {

    try {
      Response response = await wellsApiProvider.wellWorkHour(flowMeterParams);

      WellWorkEntity wellWorkEntity=WellWorkModel.fromJson(response.data);


      return DataSuccess(wellWorkEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> alertCount(FlowMeterParams flowMeterParams) async {
    try {
      Response response = await wellsApiProvider.alertCount(flowMeterParams);
      AlertCountEntity alertCountEntity=AlertCountModel.fromJson(response.data);
      return DataSuccess(alertCountEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState> flowMeter(flowMeterParams,{bool ignoreAllWell = false}) async {

    try {
      Response response = await wellsApiProvider.flowMeter(flowMeterParams);
      if(response.data["list"].isEmpty){
        return DataSuccess("");
      }else{
        WellFlowMeterEntity flowMeterEntity=WellFlowMeterModel.fromJson(response.data,ignoreAllWell: ignoreAllWell);

        return DataSuccess(flowMeterEntity);
      }


    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> getProgramList(int id) async {
    try {
      Response response = await wellsApiProvider.getProgramList(id);

      List<ProgramDayEntity> programDayEntity=parseWeeklySchedule(response.data);

      return DataSuccess(programDayEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }



}
