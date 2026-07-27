
class CreateTimeParams {

  int? code;
  String? pin;
  int? userLocalID;
  int? deviceID;
  int? weekDay ;
  String? startTime;
  String? endTime;
  int? status;
  int? day;

  CreateTimeParams({
     this.code,
     this.pin,
     this.userLocalID,
     this.deviceID,
     this.weekDay,
     this.startTime,
     this.endTime,
     this.status,
     this.day,
  });

  // CreateTimeParams copyWith(
  //     {
  //       int? newCode,
  //       int? newLimit,
  //       int? newTime,
  //       int? newPage,
  //       int? newReportType,
  //       List? newIds,
  //       String? newLevel,
  //       String? newStartDate,
  //       String? newEndDate,
  //
  //     }) {
  //   return CreateTimeParams(
  //       type: type ?? type,
  //       time: time??time,
  //       page: newPage??page,
  //       ids: newIds??ids,
  //       reportType: newReportType??reportType,
  //       limit: limit??limit,
  //       level: level??level,
  //       startDate: startDate??startDate,
  //       endDate: endDate??endDate
  //
  //
  //   );
  // }
}
