import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mahaliii/features/status_summary_feature/data/model/last_activity_model.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/last_activity_entity.dart';

import '../../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../../common/error_handling/exceptions.dart';
import '../../../../../../common/utils/data_state.dart';
import '../../../../common/params/flowmeter_params.dart';
import '../../domain/entity/summary_flowmeter_entity.dart';
import '../../domain/entity/wells_entity.dart';
import '../../domain/repository/status_summary_repository.dart';
import '../datasource/remote/status_summary_api_provider.dart';
import '../model/summary_flowmeter_model.dart';
import '../model/wells_model.dart';

class StatusSummaryRepositoryImpl extends StatusSummaryRepository {
  final StatusSummaryApiProvider statusSummaryApiProvider;
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);

  StatusSummaryRepositoryImpl({required this.statusSummaryApiProvider});

  @override
  Future<DataState<dynamic>> wellsList() async {

    try {
      List<WellsEntity> wellsEntity=[];
      Response response = await statusSummaryApiProvider.wellsList();
      for (var element in (response.data["wells"] as List)) {
        wellsEntity.add(WellsModel.fromJson(element));
      }
      return DataSuccess(wellsEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> lastActivities(FlowMeterParams flowMeterParams) async {
    try {

      Response response = await statusSummaryApiProvider.lastActivities(flowMeterParams);
       LastActivityEntity lastActivityEntity= LastActivityModel.fromJson(response.data);

      return DataSuccess(lastActivityEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState> summaryFlowMeter(flowMeterParams) async {

    try {
      Response response = await statusSummaryApiProvider.summaryFlowMeter(flowMeterParams);

      SummaryFlowMeterEntity flowMeterEntity=SummaryFlowMeterModel.fromJson(response.data);

      return DataSuccess(flowMeterEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

}
