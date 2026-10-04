
class AlertFilterModel {
  final String? status;
  final String? type;
  final String? startDate;
  final String? endDate;
  final String? wellName;
  final bool? filterType;
  final bool? filterStatus;
  final bool? filterWellName;
  final bool? filterDate;

  AlertFilterModel({this.status, this.type, this.startDate,this.endDate,
    this.wellName,this.filterType,this.filterStatus,this.filterWellName,this.filterDate});

  // کپی کردن مقادیر قبلی و جایگزینی مقادیر جدید
  AlertFilterModel copyWith({
    String? newStatus,
    String? newType,
    String? newStartDate,
    String? newEndDate,
    String? newWellName,
    bool? newFilterType,
    bool? newFilterStatus,
    bool? newFilterWellName,
    bool? newFilterDate,
  }) {
    return AlertFilterModel(
      status: newStatus??status,
      type: newType ??type,
      startDate: newStartDate ?? startDate,
      endDate: newEndDate ?? endDate,
      wellName: newWellName??wellName,
      filterType: newFilterType ??filterType,
      filterStatus: newFilterStatus ?? filterStatus,
      filterWellName: newFilterWellName ??filterWellName,
      filterDate: newFilterDate??filterDate
      // دلیل اصلی مشکل شما این خط بود که جا افتاده بود!
    );
  }

  // // تبدیل به Map برای ارسال به API (حذف گزینه‌های نال)
  // Map<String, dynamic> toApiMap() {
  //   final Map<String, dynamic> map = {};
  //   if (status != null && status!.isNotEmpty) map['status'] = status;
  //   if (type != null && type!.isNotEmpty) map['type'] = type;
  //   if (startDate != null && startDate!.isNotEmpty) map['date'] = startDate;
  //   if (wellName != null && wellName!.isNotEmpty) map['well_name'] = wellName;
  //   return map;
  // }
}