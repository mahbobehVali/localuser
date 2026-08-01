import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/features/alert_feature/data/datasource/remote/alert_api_provider.dart';
import 'package:mahaliii/features/alert_feature/data/model/alerts_model.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alerts_entity.dart';
import 'package:mahaliii/features/report_feature/data/model/capacity_model.dart';
import 'package:mahaliii/features/report_feature/domain/entity/capacity_entity.dart';
import 'package:mahaliii/features/support_feature/data/model/support_answer_model.dart';
import 'package:mahaliii/features/support_feature/data/model/support_model.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_entity.dart';
import 'package:mahaliii/features/well_feature/data/datasource/remote/wells_api_provider.dart';

import '../../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../../common/error_handling/exceptions.dart';
import '../../../../../../common/utils/data_state.dart';
import '../../../../common/params/alert_filter_params.dart';
import '../../../../common/params/send_new_request_to_support_params.dart';
import '../../domain/entity/support_answer_entity.dart';
import '../../domain/repository/support_repository.dart';
import '../datasource/remote/support_api_provider.dart';

class SupportRepositoryImpl extends SupportRepository {
  final SupportApiProvider supportApiProvider;
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);

  SupportRepositoryImpl({required this.supportApiProvider});

  @override
  Future<DataState<dynamic>> getSupportMessage(FlowMeterParams flowMeterParams) async {

    try {

      Response response = await supportApiProvider.getSupportMessage(flowMeterParams);
      SupportEntity supportEntity=SupportModel.fromJson(response.data);

      return DataSuccess(supportEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> getSupportAnswers(int id) async {
    try {

      Response response = await supportApiProvider.getSupportAnswers(id);
      SupportAnswerEntity supportEntity=SupportAnswerModel.fromJson(response.data);

      return DataSuccess(supportEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> sendSupport(SendNewSupportParams sendNewSupportParams) async {
    try {

      Response response = await supportApiProvider.sendSupport(sendNewSupportParams);
      SupportAnswerEntity supportEntity=SupportAnswerModel.fromJson(response.data);

      return DataSuccess(supportEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }





}
