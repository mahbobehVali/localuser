import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/forget_password_params.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../common/params/login_params.dart';

class AuthApiProvider {
  Dio dio;

  AuthApiProvider(this.dio);

  Future<dynamic> login(LoginParams loginParams) async {
    try {
      var response = await dio.post(
        "user/login",
        data: {
          "mobile": loginParams.mobile,
          "password": loginParams.password,
        },
      );
      print(response.data);

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

  Future<dynamic> getCode(String mobile) async {
    print("sfsdf${mobile.toString().toEnglishDigit()}");

    try {
      var response = await dio.post(
        "user/validate",
        data: {
          "mobile": mobile.toString().toEnglishDigit(),

        },
      );

      return response;
    } on DioException catch (e) {
      print(e.response?.statusCode);
      print(e.response);
      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> forgetPass(ForgetPasswordParams forgetPasswordParams) async {
    try {
      var response = await dio.post(
        "user/password/reset",
        data: {
          "mobile": forgetPasswordParams.mobile,
          "password": forgetPasswordParams.password,
          "code": forgetPasswordParams.code,
          "smsID": forgetPasswordParams.serverId,
        },
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