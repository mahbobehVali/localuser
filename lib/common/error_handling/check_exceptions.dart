import 'dart:developer';

import 'package:dio/dio.dart';

import '../utils/data_state.dart';
import 'exceptions.dart';

class CheckExceptions {
  ///use in apiProvider file
   static dynamic response(Response? response,[bool? possible]) {

    switch (response?.statusCode ?? -1) {
      case 200:
        return response;

      case 400:
        throw UnauthenticatedException();

      case 401:
        throw NotAllowedToEnterException(response: response);

        //شماره شما در سامانه ثبت نشده(فراموشی رمز)
    //نظر خود را ثبت کرده اید(نظر در مورد مشاوره)
    //   case 404:
    //     throw UnauthenticatedException();

      //مهلت کد اعتبارسنجی به پایان رسیده
      case 408:
        throw VerificationCodeExpiredException();

      //قبلا ثبت نام کردی
    //رمز فعلی اشتباه در حساب کاربری
      case 422:
        throw AlreadyRegisteredException(response: response);
   //15 دقیقه دیگر تلاش کنید
      case 429:
        throw OverLimitException(response: response);

      case 500:
        throw ServerException(response: response);


      default:
        throw FetchDataException(
            message: "خطایی رخ داده است. دوباره تلاش کنید.");
    }
  }

  ///use in repository file
  static Future<DataState> getError(AppException appException,{bool? password}) async {
     print(password);
    switch (appException.runtimeType) {
      ///wrong username or password, inactive userAccount, checking documents, wrong verificationCode

      case NotAllowedToEnterException:
        return DataFailed(error: appException.response!.data["message"],
            isNotLogin: true,isTokenExpired: true
        );


      ///The user is not registered in the system

      case UnauthenticatedException:
        return DataFailed(error: appException.response!.data["message"]);

      ///The verification code has expired

      case VerificationCodeExpiredException:
        return DataFailed(error: appException.message);

      ///Already registered

      case AlreadyRegisteredException:
        return DataFailed(
            error: password==true?
            appException.response!.data["message"]:
            // appException.response!.data["errors"]["mobile"][0]
            "خطایی رخ داده"

        );
      ///Request more than the limit

      case OverLimitException:
        return DataFailed(error: appException.message);

      /// server error
      case ServerException:
        return DataFailed(error: appException.message);

      /// dio or timeout and etc error
      default:
        log(appException.message);
        return DataFailed(error: appException.message);
    }
  }

// static dynamic callPreviousApiAgain(AppException appException) async {
//   Dio dio = locator<Dio>();
//   ApiConfig.setHeader(dio: dio, token: await SharedPrefOperator.getUserToken());
//
//   RequestOptions requestOptions = appException.response!.requestOptions;
//   var response = await dio.request(
//   requestOptions.path,
//   cancelToken: requestOptions.cancelToken,
//   onReceiveProgress: requestOptions.onReceiveProgress,
//   data: requestOptions.data,
//   queryParameters: requestOptions.queryParameters);
//
//   response = CheckExceptions.response(response);
//   return response;
// }


}
