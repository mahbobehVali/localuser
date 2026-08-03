import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/send_new_request_to_support_params.dart';

import '../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../common/params/alert_filter_params.dart';

class AlertApiProvider {
  Dio dio;

  AlertApiProvider(this.dio);

  Future<dynamic> alerts(AlertFilterParams alertFilterParams) async {

    try {
      var response = await dio.get(
        "alert/list",
        queryParameters: {
          "limit":10,
          "page":alertFilterParams.page,
          if (alertFilterParams.type != null) "type": alertFilterParams.type,
          if (alertFilterParams.status != null) "status": alertFilterParams.status,
          if (alertFilterParams.wellName != null) "well_name": alertFilterParams.wellName,
          if (alertFilterParams.startDate != null) "startDate": alertFilterParams.startDate,
          if (alertFilterParams.endDate != null) "endDate": alertFilterParams.endDate,
        }
      );

      return response;
    } on DioException catch (e) {

      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }
  Future<dynamic> detailAlert(int id) async {
    try {
      var response = await dio.get(
        "alert/response/list/$id",
      );

      return response;
    } on DioException catch (e) {

      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> alertCreate(SendNewSupportParams sendNewSupportParams) async {
    try {
      var response = await dio.post(
        "alert/create",
        data: {
          "status":sendNewSupportParams.status,
          "message":sendNewSupportParams.description,
          "id":sendNewSupportParams.id,
        }
      );

      return response;
    } on DioException catch (e) {
      print(e.response);
      print(e.response?.statusCode);

      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }

}