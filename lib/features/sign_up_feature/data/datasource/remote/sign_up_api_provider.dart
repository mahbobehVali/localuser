import 'package:dio/dio.dart';

import '../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../common/params/sign_up_params.dart';

class SignUpApiProvider {
  Dio dio;

  SignUpApiProvider(this.dio);

  /// type =0 for local user and 1 for supeizer

  Future<dynamic> firstSignUp(
      SignUpParams signUpParams,
      ) async {


    try {
      var response = await dio.post("user/validate", data: {

        "mobile": signUpParams.mobile,
        "nationalCode": signUpParams.nationalCode,
        "login":1
      }
      );
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }


  Future<dynamic> register(
    SignUpParams signUpParams,
  ) async {

    try {
      var response = await dio.post(
        "user/register",
        data:{
          "areaID": signUpParams.areaId,
          "mobile": signUpParams.mobile,
          "name": signUpParams.name,
          "national_code": signUpParams.nationalCode,
          "password": signUpParams.password,
          "type": signUpParams.type,
          "code": signUpParams.code,
          "smsID": signUpParams.serverId,
        },
      );
      return response;
    } on DioException catch (e) {

      return CheckExceptions.response(e.response);
    }
  }
  Future<dynamic> getRegions() async {

    try {
      final response = await dio.get("user/regions");
      return response;
    } on DioException catch (e) {

      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> getArea(int id) async {

    try {
      final response = await dio.get("user/region/$id");
      return response;
    } on DioException catch (e) {

      return CheckExceptions.response(e.response);
    }
  }

}
