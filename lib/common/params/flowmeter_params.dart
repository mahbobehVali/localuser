
class FlowMeterParams {

  int? type;
  int? limit;
  int? time;
  int? page;
  int? reportType;
  List? ids;
  String? level;
  String? startDate;
  String? endDate;
  bool? total;


  FlowMeterParams({
     this.limit,
     this.type,
     this.time,
     this.page,
     this.reportType,
     this.ids,
     this.level,
     this.startDate,
     this.endDate,
     this.total=false,
  });

  FlowMeterParams copyWith(
      {
        int? newType,
        int? newLimit,
        int? newTime,
        int? newPage,
        int? newReportType,
        List? newIds,
        String? newLevel,
        String? newStartDate,
        String? newEndDate,
        bool? newTotal

      }) {
    return FlowMeterParams(
        type: type ?? type,
        time: time??time,
        page: newPage??page,
        ids: newIds??ids,
        reportType: newReportType??reportType,
        limit: limit??limit,
        level: level??level,
        startDate: startDate??startDate,
        endDate: endDate??endDate,
      total: newTotal??false


    );
  }
}
