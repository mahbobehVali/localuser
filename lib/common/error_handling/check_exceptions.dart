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

        //موبایل یا رمز اشتباه برای ورود message
      case 400:
        throw UnauthenticatedException(response: response);

        //  موبایل یا رمز عبور اشتباه است برای ورود message
        // حساب کاربری شما غیرفعال هست
        // message کد اعتبارسنجی اشتباه
      case 401:
        throw NotAllowedToEnterException(response: response);

          // شماره شما در سامانه ثبت نشده(فراموشی رمز) mobile
        case 404:
          throw UnaverificatedException(response: response);

        // message  کد اعتبارسنجی منقضی
      case 408:
        throw VerificationCodeExpiredException(response: response);

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
        final data = appException.response?.data;
        final errorMessage = (data is Map && data.containsKey('message') && data['message'] != null)
            ? data['message']
            : 'خطایی رخ داده'; // پیام پیش‌فرض در صورت نبود کلید message

        return DataFailed(error: errorMessage,isNotLogin: true,isTokenExpired: true);


      ///The user is not registered in the system

      case UnauthenticatedException:
        final data = appException.response?.data;
        print("data${appException.response??""}");
        final errorMessage = (data is Map && data.containsKey('message') && data['message'] != null)
            ? data['message']
            : 'خطایی رخ داده'; // پیام پیش‌فرض در صورت نبود کلید message

        return DataFailed(error: errorMessage);

 case UnaverificatedException:
   final data = appException.response?.data;
   final errorMessage = (data is Map && data.containsKey('mobile') && data['mobile'] != null)
       ? data['mobile']
       : 'خطایی رخ داده'; // پیام پیش‌فرض در صورت نبود کلید message

   return DataFailed(error: errorMessage);

      ///The verification code has expired

      case VerificationCodeExpiredException:
        final data = appException.response?.data;
        final errorMessage = (data is Map && data.containsKey('message') && data['message'] != null)
            ? data['message']
            : 'خطایی رخ داده'; // پیام پیش‌فرض در صورت نبود کلید message

        return DataFailed(error: errorMessage);


      ///Already registered

      case AlreadyRegisteredException:
        final data = appException.response?.data;
        String errorMessage = 'خطایی رخ داده';

        if (data is Map) {
          final errors = data['errors'];

          // ۱. بررسی وجود لیست خطاها و خالی نبودن آن
          if (errors is List && errors.isNotEmpty) {
            if (errors.length == 1) {
              errorMessage = errors[0].toString();
            } else {
              errorMessage = '${errors[0]}\n${errors[1]}';
            }
          }
          // ۲. اگر لیست errors نبود، کلید message بررسی می‌شود
          else if (data['message'] != null) {
            errorMessage = data['message'].toString();
          }
        }

        return DataFailed(error: errorMessage);

      case WrongPreviousPasswordException:
        final data = appException.response?.data;
        final errorMessage = (data is Map && data.containsKey('message') && data['message'] != null)
            ? data['message']
            : 'خطایی رخ داده'; // پیام پیش‌فرض در صورت نبود کلید message

        return DataFailed(error: errorMessage);


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
