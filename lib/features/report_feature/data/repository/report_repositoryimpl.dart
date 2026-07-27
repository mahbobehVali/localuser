import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/features/alert_feature/data/datasource/remote/alert_api_provider.dart';
import 'package:mahaliii/features/alert_feature/data/model/alerts_model.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alerts_entity.dart';
import 'package:mahaliii/features/report_feature/data/model/capacity_model.dart';
import 'package:mahaliii/features/report_feature/domain/entity/capacity_entity.dart';
import 'package:mahaliii/features/well_feature/data/datasource/remote/wells_api_provider.dart';

import '../../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../../common/error_handling/exceptions.dart';
import '../../../../../../common/utils/data_state.dart';
import '../../../../common/params/alert_filter_params.dart';
import '../../domain/repository/report_repository.dart';
import '../datasource/remote/report_api_provider.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportApiProvider reportApiProvider;
  final AlertApiProvider alertApiProvider;
  final WellsApiProvider wellsApiProvider;
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);

  ReportRepositoryImpl({required this.reportApiProvider,required this.alertApiProvider,required this.wellsApiProvider});

  @override
  Future<DataState<dynamic>> alerts(AlertFilterParams alertFilterParams) async {

    try {

      Response response = await alertApiProvider.alerts(alertFilterParams);
      AlertsEntity alertEntity=AlertsModel.fromJson(response.data);

      return DataSuccess(alertEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }


  @override
  Future<DataState<dynamic>> getCapacity(FlowMeterParams flowMeterParams) async {
    try {
      Response response = await reportApiProvider.getCapacity(flowMeterParams);

      CapacityEntity capacityEntity=CapacityModel.fromJson(response.data);


      return DataSuccess(capacityEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }



}
