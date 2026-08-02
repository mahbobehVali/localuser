import 'dart:async';

import 'package:dio/dio.dart';
import 'package:mahaliii/features/alert_feature/data/model/alert_detail_model.dart';
import 'package:mahaliii/features/alert_feature/data/model/alerts_model.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_detail_entity.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alerts_entity.dart';

import '../../../../../../common/error_handling/check_exceptions.dart';
import '../../../../../../common/error_handling/exceptions.dart';
import '../../../../../../common/utils/data_state.dart';
import '../../../../common/params/alert_filter_params.dart';
import '../../domain/repository/alert_repository.dart';
import '../datasource/remote/alert_api_provider.dart';

class AlertRepositoryImpl extends AlertRepository {
  final AlertApiProvider alertApiProvider;
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);

  AlertRepositoryImpl({required this.alertApiProvider});

  @override
  Future<DataState<dynamic>> alerts(AlertFilterParams alertFilterParams) async {

    try {

      Response response = await alertApiProvider.alerts(alertFilterParams);

        AlertsEntity alertEntity=AlertsModel.fromJson(response.data);
        return DataSuccess(alertEntity);

    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> detailAlert(int id) async {
    try {

      Response response = await alertApiProvider.detailAlert(id);

        List<AlertDetailEntity> alertEntity=AlertDetailModel.parseList(response.data);

        return DataSuccess(alertEntity);


    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }



}
