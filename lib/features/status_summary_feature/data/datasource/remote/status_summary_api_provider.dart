import 'package:dio/dio.dart';

import '../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../common/params/flowmeter_params.dart';

class StatusSummaryApiProvider {
  Dio dio;

  StatusSummaryApiProvider(this.dio);

  //گزارش وصعیت آب
  Future<dynamic> flowMeter(FlowMeterParams flowMeterParams) async {
    print("flowMeterParams.ids${flowMeterParams.ids}");

    var data = {
      //0 today 6 currentWeek
      "type":flowMeterParams.type,
      //deviceId
      "id":flowMeterParams.ids,
      // "reportType":0,
      "level":"area"
    };

    try {
      final response = await dio.post("report/flowmeter",data: data);
      print("response${response.data}");
      return response;
    } on DioException catch (e) {
      print("response${e.response?.statusCode}");
      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> wellsList() async {
    try {
      var response = await dio.get(
        "user/well",
      );

      return response;
    } on DioException catch (e) {

      if (e.type == DioExceptionType.connectionError) {
        print("خطا در اتصال: احتمالاً مشکل CORS یا اینترنت است");
      }

      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> lastActivities(FlowMeterParams flowMeterParams) async {

    var data =flowMeterParams.type==5?{
      "type":flowMeterParams.type,
      "ids":flowMeterParams.ids,
      "startDate":flowMeterParams.startDate,
      "endDate":flowMeterParams.endDate,
      "startTime":"00:00",
      "endTime":"23:59",
      "limit":5,
      "page":flowMeterParams.page,

    }: {
      "type":flowMeterParams.type,
      ///own:1 manage own wells
      "own":1,
      "limit":5,
      "page":flowMeterParams.page,
    };

    try {
      var response = await dio.post(
        "report/command/list",
        data: data
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