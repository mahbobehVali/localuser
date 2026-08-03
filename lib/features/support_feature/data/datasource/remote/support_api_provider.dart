import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/send_new_request_to_support_params.dart';

import '../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../common/params/flowmeter_params.dart';

class SupportApiProvider {
  Dio dio;

  SupportApiProvider(this.dio);
  Future<dynamic> getSupportMessage(FlowMeterParams flowMeterParams) async {

    var data ={
      "page":flowMeterParams.page,
      "limit":6,
      if(flowMeterParams.status!=null) "status":flowMeterParams.status
    };

    try {
      final response = await dio.get("support/list",queryParameters: data);
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> getSupportAnswers(int id) async {

    try {
      final response = await dio.get("support/answer/$id");
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> sendSupport(SendNewSupportParams sendNewSupportParams) async {

    try {
      final response = await dio.post("support/create",
      data: {
        "part":sendNewSupportParams.part,
        "subject":sendNewSupportParams.subject,
        "description":sendNewSupportParams.description,
        "status":sendNewSupportParams.status


      });
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> sendAnswer(SendNewSupportParams sendNewSupportParams) async {

    try {
      final response = await dio.post("support/answer",
      data: {
        "support_id":sendNewSupportParams.id,
        "description":sendNewSupportParams.description,
         if(sendNewSupportParams.payVast!=null) "file":sendNewSupportParams.payVast,
        "status":2
      });
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> supportClose(int id) async {

    try {
      final response = await dio.post("support/close",
      data: {
        "support_id":id,
      });
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

}