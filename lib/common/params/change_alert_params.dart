class ChangeAlertParams {
  final bool res;
  final bool region;
  final bool area;

  const ChangeAlertParams({
    this.res = false,
    this.region = false,
    this.area = false,
  });

  ChangeAlertParams copyWith({
    bool? newRes,
    bool? newRegion,
    bool? newArea,
  }) {
    return ChangeAlertParams(
      res: newRes ?? this.res,
      region: newRegion ?? this.region,
      area: newArea ?? this.area,
    );
  }
}