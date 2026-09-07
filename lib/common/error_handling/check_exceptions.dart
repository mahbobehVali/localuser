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

        //نام کاربری اشتباه است
      case 400:
        throw UnauthenticatedException();

        //  رمز عبور اشتباه است
        // حساب کاربری شما غیرفعال هست
        // کد اعتبارسنجی اشتباه
      case 401:
        throw NotAllowedToEnterException(response: response);

          //شماره شما در سامانه ثبت نشده(فراموشی رمز)
      //نظر خود را ثبت کرده اید(نظر در مورد مشاوره)
        case 404:
          throw UnaverificatedException(response: response);

        //کد اعتبارسنجی منقضی
      case 408:
        throw VerificationCodeExpiredException();

        //ثبت نام: کد ملی یا شماره تکراری
      case 409:
        throw AlreadyRegisteredException(response: response);


        // رمز عبور قبلی درست نیست
      case 422:
        throw WrongPreviousPasswordException(response: response);

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
        return DataFailed(error: appException.response?.data["mobile"]);

 case UnaverificatedException:
        return DataFailed(error: appException.response?.data["mobile"]);

      ///The verification code has expired

      case VerificationCodeExpiredException:
        return DataFailed(error: appException.message);


      ///Already registered

      case AlreadyRegisteredException:
        return DataFailed(
            error:
            // password==true?
            appException.response!.data["errors"].length==1? appException.response!.data["errors"][0]:
                "${appException.response!.data["errors"][0]}\n${appException.response!.data["errors"][1]}"
            // appException.response!.data["errors"]["mobile"][0]
            // "خطایی رخ داده"

        );

      case WrongPreviousPasswordException:
        return DataFailed(
            error:
            appException.response!.data["message"]

        );

      case AlreadyRegisteredException:
        return DataFailed(
            error:
            // password==true?
            appException.response!.data["message"]
          // appException.response!.data["errors"]["mobile"][0]
          // "خطایی رخ داده"

        );

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
