import 'package:dio/dio.dart';

///  ///use in repository file
class AppException implements Exception {
  final String message;
  Response? response;
  bool? password;

  AppException({required this.message, this.response,this.password});

  String getMessage() {
    return message;
  }
}


class NotAllowedToEnterException extends AppException {
  NotAllowedToEnterException({String? message, super.response})
      : super(
            message: message ?? "کد اعتبارسنجی اشتباه است");
}

class WrongPreviousPasswordException extends AppException {
  WrongPreviousPasswordException({String? message, super.response})
      : super(
            message: message ?? "شماره موبایل یا کد ملی اشتباه است");
}

class UnauthenticatedException extends AppException {
  UnauthenticatedException({String? message, super.response})
      : super(
            message: message ?? "چنین کاربری یافت نشد");
}

class UnaverificatedException extends AppException {
  UnaverificatedException({String? message, super.response})
      : super(
            message: message ?? "چنین کاربری یافت نشد");
}


class AlreadyRegisteredException extends AppException {
  AlreadyRegisteredException({String? message, super.response,bool? password})
      : super(
            message: message ??
                "شما قبلا ثبت نام کرده اید");
}


// class DataParsingException extends AppException {
//   DataParsingException({String? message_bloc})
//       : super(message_bloc: message_bloc ?? "Data has Corrupted");
// }

class ServerException extends AppException {
  ServerException({String? message, super.response})
      : super(
      message: message ??
          "مشکلی در سرور به وجود آمده است. لطفا مجدد امتحان کنید.");
}

class FetchDataException extends AppException {
  FetchDataException({String? message})
      : super(message: message ?? "لطفا اینترنت خود را بررسی کنید ...");
}

class VerificationCodeExpiredException extends AppException {
  VerificationCodeExpiredException({String? message,super.response})
      : super(message: message ?? " مهلت استفاده از کد به پایان رسیده است.");
}

