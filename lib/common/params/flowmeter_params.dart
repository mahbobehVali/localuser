
class FlowMeterParams {

  int? status;
  int? type;
  int? limit;
  int? time;
  int? page;
  int? reportType;
  dynamic ids;
  String? level;
  String? startDate;
  String? endDate;
  String? startHour;
  String? endHour;
  bool? total;


  FlowMeterParams({
     this.status,
     this.limit,
     this.type,
     this.time,
     this.page,
     this.reportType,
     this.ids,
     this.level,
     this.startDate,
     this.endDate,
     this.startHour,
     this.endHour,
     this.total=false,
  });

  FlowMeterParams copyWith(
      {
        int? newStatus,
        int? newType,
        int? newLimit,
        int? newTime,
        int? newPage,
        int? newReportType,
        dynamic newIds,
        String? newLevel,
        String? newStartDate,
        String? newEndDate,
        String? newStartHour,
        String? newEndHour,
        bool? newTotal

      }) {
    return FlowMeterParams(
        status: newStatus ?? status,
        type: newType ?? type,
        time: newTime??time,
        page: newPage??page,
        ids: newIds??ids,
        reportType: newReportType??reportType,
        limit: newLimit??limit,
        level: newLevel??level,
        startDate: newStartDate??startDate,
        endDate: newEndDate??endDate,
        startHour: newStartHour??startHour,
        endHour: newEndHour??endHour,
      total: newTotal??false


    );
  }
}
