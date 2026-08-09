import 'package:dio/dio.dart';

import '../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../common/params/flowmeter_params.dart';

class WellsApiProvider {
  Dio dio;

  WellsApiProvider(this.dio);

  Future<dynamic> wellWorkHour(FlowMeterParams flowMeterParams) async {
    var data =flowMeterParams.type==5?{
      "type":flowMeterParams.type,
      "ids":flowMeterParams.ids,
      "reportType":0,
      "startDate":flowMeterParams.startDate,
      "endDate":flowMeterParams.endDate,
      "startTime":"00:00",
      "endTime":"23:59",
    }: {
      "type":flowMeterParams.type,
      "ids":flowMeterParams.ids,
      "reportType":0,
    };

    try {
      final response = await dio.post("report/command/count",data: data);
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> alertCount(FlowMeterParams flowMeterParams) async {
    print(flowMeterParams.startDate);
    print(flowMeterParams.endDate);
    print(flowMeterParams.ids);

    var data =flowMeterParams.time==-1? {

      "startDate":flowMeterParams.startDate,
      "endDate":flowMeterParams.endDate,
      "ids":"${flowMeterParams.ids}",
      "reportType":0
    }:{
      "time":flowMeterParams.time,
      "ids":"${flowMeterParams.ids}",
    };
    try {
      final response = await dio.get("alert/count",queryParameters:data);
      return response;
    } on DioException catch (e) {

      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> flowMeter(FlowMeterParams flowMeterParams) async {


    var data= flowMeterParams.type==5?{
      "type":flowMeterParams.type,
      "ids":flowMeterParams.ids,
      "reportType":0,
      "startDate":flowMeterParams.startDate,
      "endDate":flowMeterParams.endDate,
      "startTime":"00:00",
      "endTime":"23:59",
    }:  {
      "type":flowMeterParams.type,
      "ids":flowMeterParams.ids,
      "reportType":0,
    };

    try {
      final response = await dio.post("report/flowmeter",data: data);

      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }

  Future<dynamic> getProgramList(int id) async {

    try {
      final response = await dio.get("equipment/$id/program/list");
      return response;
    } on DioException catch (e) {
      return CheckExceptions.response(e.response);
    }
  }


}