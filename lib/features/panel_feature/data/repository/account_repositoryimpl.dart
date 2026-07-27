import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/change_password_params.dart';

import '../../../../common/error_handling/check_exceptions.dart';
import '../../../../common/error_handling/exceptions.dart';
import '../../../../common/utils/data_state.dart';
import '../../domain/repository/account_repository.dart';
import '../datasource/remote/account_provider.dart';


class PanelRepositoryImpl extends PanelRepository {
  final PanelApiProvider panelApiProvider;
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);

  PanelRepositoryImpl({required this.panelApiProvider});

  @override
  Future<DataState<dynamic>> sendSms() async {
    try {

      Response response = await panelApiProvider.sendSms();

      return DataSuccess(response.data["smsID"]);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> changePassword(ChangePasswordParams changePasswordParams) async {
    try {

       await panelApiProvider.changePassword(changePasswordParams);

      return DataSuccess("");
    } on AppException catch (e) {
      return CheckExceptions.getError(e,password:e.response?.statusCode==422? true:false);
    }
  }

  @override
  Future<DataState<dynamic>> changeAlert(int type) async {
    try {

      Response response = await panelApiProvider.changeAlert(type);

      return DataSuccess(response.data);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }


}
