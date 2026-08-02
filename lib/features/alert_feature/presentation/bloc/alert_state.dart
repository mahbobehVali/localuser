part of 'alert_bloc.dart';


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
  });

  AlertState copyWith(
      {AlertStatus? newAlertStatus,
        int? newSelectedAlertPage,

        String? newWellName,
        String? newDate,
        AlertWellListStatus? newAlertWellListStatus,
        WellsEntity? newOneWell,
        List<AlertTypeEntity>? newAlertTypeList,
        int? newSelectedAlertType,
        List<AlertTypeEntity>? newAlertStatusList,
        int? newSelectedAlertStatus,
        String? newAlertStartDate,
        String? newAlertEndDate,
        AlertFilterModel? newAlertFilterModel,
        AlertDetailStatus? newAlertDetailStatus

      }) {
    return AlertState(
        alertStatus: newAlertStatus ?? alertStatus,
      selectedAlertPage: newSelectedAlertPage??selectedAlertPage,

      wellName: newWellName??wellName,
      date: newDate??date,

      alertWellListStatus: newAlertWellListStatus??alertWellListStatus,
      oneWell: newOneWell??oneWell,
      alertTypeList: newAlertTypeList??alertTypeList,
      selectedAlertType: newSelectedAlertType??selectedAlertType,
      alertStatusList: newAlertStatusList??alertStatusList,
      selectedAlertStatus: newSelectedAlertStatus??selectedAlertStatus,
      alertStartDate: newAlertStartDate??alertStartDate,
      alertEndDate: newAlertEndDate??alertEndDate,
      alertFilterModel: newAlertFilterModel??alertFilterModel,
      alertDetailStatus: newAlertDetailStatus?? alertDetailStatus

    );
  }
}
