

class AlertFilterParams{
  int? status;
  int? page;
  String? startDate;
  String? endDate;
  String? wellName;
  int? regionId;
  int? areaId;
  int? type;
  bool? ok;
  String? level;
  int? id;
  AlertFilterParams(
      {this.status,this.page, this.startDate, this.endDate,this.wellName, this.regionId,this.areaId,this.type,this.ok,this.level,this.id});
  // AlertFilterParams copyWith(
  //     {
  //       int? newStatus,
  //       String? newStartDate,
  //       String? newEndDate,
  //       int? newRegionId,
  //       int? newAreaId,
  //       int? newType,
  //       bool? newOk,
  //
  //
  //
  //     }) {
  //   return  AlertFilterParams(
  //       status: newStatus ?? status,
  //       startDate: newStartDate??startDate,
  //       endDate: newEndDate??endDate,
  //       regionId: newRegionId??regionId,
  //       areaId: newAreaId??areaId,
  //       type: newType??type,
  //     ok: newOk??ok
  //
  //
  //   );
  // }

}