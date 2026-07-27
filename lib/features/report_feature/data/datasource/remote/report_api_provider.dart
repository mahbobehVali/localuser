import 'package:dio/dio.dart';

import '../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../common/params/flowmeter_params.dart';

class ReportApiProvider {
  Dio dio;

  ReportApiProvider(this.dio);
  Future<dynamic> getCapacity(FlowMeterParams flowMeterParams) async {

    var data ={
      "reportType":0,
      "ids":"${flowMeterParams.ids}",
    };

    try {
      final response = await dio.get("report/capacity/list",queryParameters: data);
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

}