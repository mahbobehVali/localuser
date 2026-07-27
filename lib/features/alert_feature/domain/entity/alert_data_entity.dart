class AlertDataEntity {
  String? wellName;
      int? id;
  int? type;
      int? status;
  String? deviceId;
      String? areaId;
  String? regionId;
      String? areaName;
  String? regionName;
      String? message;
  String? date;
      String? clock;
      String? createdAt;


  AlertDataEntity( this.wellName,this.id,this.type, this.status,this.deviceId,this.areaId,this.regionId,
      this.areaName,this.regionName,this.message,this.date,this.clock,this.createdAt);
}
