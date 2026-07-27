import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/change_password_params.dart';

import '../../../../../common/error_handling/check_exceptions.dart';

class PanelApiProvider {
  Dio dio;

  PanelApiProvider(this.dio);

  Future<dynamic> sendSms() async {
    try {
      var response = await dio.get(
        "user/send/sms",
      );

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }
  Future<dynamic> changePassword(ChangePasswordParams changePasswordParams) async {
    try {
      var response = await dio.post(
        "user/change/password",
        data: {
          "code":changePasswordParams.code,
          "smsID":changePasswordParams.serverId,
          "oldPassword":changePasswordParams.oldPassword,
          "newPassword":changePasswordParams.newPassword,
        }
      );

      return response;
    } on DioException catch (e) {
      print(e.response!.statusCode);
      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }
  Future<dynamic> changeAlert(int type) async {
    // type=0 sms 1 phone 2 both
    try {
      var response = await dio.patch(
        "user/update/sms/type/$type",
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }

}