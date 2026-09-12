part of 'alert_bloc.dart';


// یک شیء اختصاصی برای تشخیص مقدار پیش‌فرض
const _undefined = Object();

class AlertState {
  final AlertStatus? alertStatus;
  final int? selectedAlertPage;
  final String? wellName;
  final String? date;
  final AlertWellListStatus? alertWellListStatus;
  final WellsEntity? oneWell;
  final List<AlertTypeEntity> alertTypeList;
  final List<AlertTypeEntity> alertStatusList;
  final int? selectedAlertType;
  final int? selectedAlertStatus;
  final String? alertStartDate;
  final String? alertEndDate;
  final AlertFilterModel? alertFilterModel;
  final AlertDetailStatus? alertDetailStatus;
  final AlertCreateStatus? alertCreateStatus;
  final int? alert;

  AlertState({
    required this.alertStatus,
    required this.selectedAlertPage,
    required this.wellName,
    required this.date,
    required this.alertWellListStatus,
    required this.oneWell,
    required this.alertTypeList,
    required this.alertStatusList,
    required this.selectedAlertType,
    required this.selectedAlertStatus,
    required this.alertStartDate,
    required this.alertEndDate,
    required this.alertFilterModel,
    required this.alertDetailStatus,
    required this.alertCreateStatus,
    required this.alert,
  });

  AlertState copyWith({
    Object? newAlertStatus = _undefined,
    Object? newSelectedAlertPage = _undefined,
    Object? newWellName = _undefined,
    Object? newDate = _undefined,
    Object? newAlertWellListStatus = _undefined,
    Object? newOneWell = _undefined,
    Object? newAlertTypeList = _undefined,
    Object? newSelectedAlertType = _undefined,
    Object? newAlertStatusList = _undefined,
    Object? newSelectedAlertStatus = _undefined,
    Object? newAlertStartDate = _undefined,
    Object? newAlertEndDate = _undefined,
    Object? newAlertFilterModel = _undefined,
    Object? newAlertDetailStatus = _undefined,
    Object? newAlertCreateStatus = _undefined,
    Object? newAlert = _undefined,
  }) {
    return AlertState(
      alertStatus: newAlertStatus == _undefined ? alertStatus : newAlertStatus as AlertStatus?,
      selectedAlertPage: newSelectedAlertPage == _undefined ? selectedAlertPage : newSelectedAlertPage as int?,
      wellName: newWellName == _undefined ? wellName : newWellName as String?,
      date: newDate == _undefined ? date : newDate as String?,
      alertWellListStatus: newAlertWellListStatus == _undefined ? alertWellListStatus : newAlertWellListStatus as AlertWellListStatus?,
      oneWell: newOneWell == _undefined ? oneWell : newOneWell as WellsEntity?,
      alertTypeList: newAlertTypeList == _undefined ? alertTypeList : newAlertTypeList as List<AlertTypeEntity>,
      selectedAlertType: newSelectedAlertType == _undefined ? selectedAlertType : newSelectedAlertType as int?,
      alertStatusList: newAlertStatusList == _undefined ? alertStatusList : newAlertStatusList as List<AlertTypeEntity>,
      selectedAlertStatus: newSelectedAlertStatus == _undefined ? selectedAlertStatus : newSelectedAlertStatus as int?,
      alertStartDate: newAlertStartDate == _undefined ? alertStartDate : newAlertStartDate as String?,
      alertEndDate: newAlertEndDate == _undefined ? alertEndDate : newAlertEndDate as String?,
      alertFilterModel: newAlertFilterModel == _undefined ? alertFilterModel : newAlertFilterModel as AlertFilterModel?,
      alertDetailStatus: newAlertDetailStatus == _undefined ? alertDetailStatus : newAlertDetailStatus as AlertDetailStatus?,
      alertCreateStatus: newAlertCreateStatus == _undefined ? alertCreateStatus : newAlertCreateStatus as AlertCreateStatus?,
      alert: newAlert == _undefined ? alert : newAlert as int?,
    );
  }
}