class WellsDataEntity {
  int? level;
  int? userLocalId;
  String? pin;
  dynamic lat;
  dynamic lon;
  int? statusDevice;
  int? statusWell;
 String? wellName;
  int? areaId;
  int? deviceId;
  int? code;
  int? flowMeter;
  int? id;
  int? alert;

  WellsDataEntity(this.level, this.userLocalId,this.pin,this.lat,this.lon,this.statusDevice,this.statusWell, this.wellName, this.areaId,this.deviceId,this.code,this.flowMeter,this.id,this.alert);
}
