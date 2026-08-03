import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/features/support_feature/data/model/support_answer_model.dart';
import 'package:mahaliii/features/support_feature/data/model/support_model.dart';
import 'package:mahaliii/features/support_feature/domain/entity/support_entity.dart';

import '../../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../../common/error_handling/exceptions.dart';
import '../../../../../../common/utils/data_state.dart';
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

      return DataSuccess(response.data);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> sendAnswer(SendNewSupportParams sendNewSupportParams) async {
    try {

      Response response = await supportApiProvider.sendAnswer(sendNewSupportParams);

      return DataSuccess(response.data);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> supportClose(int id) async {
    try {

      Response response = await supportApiProvider.supportClose(id);

      return DataSuccess(response.data);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }





}
