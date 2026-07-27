import 'package:dio/dio.dart';
import 'package:mahaliii/common/params/forget_password_params.dart';

import '../../../../common/error_handling/check_exceptions.dart';
import '../../../../common/error_handling/exceptions.dart';
import '../../../../common/utils/data_state.dart';
import '../../domain/entity/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasource/remote/auth_api_provider.dart';
import '../model/auth_model.dart';


class AuthRepositoryImpl extends AuthRepository {
  final AuthApiProvider authApiProvider;
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);

  AuthRepositoryImpl({required this.authApiProvider});

  @override
  Future<DataState<dynamic>> login(loginParams) async {
    try {
      Response response = await authApiProvider.login(loginParams);
      AuthEntity authEntity = AuthModel.fromJson(response.data);
      return DataSuccess(authEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> getCode(String mobile) async {
    try {
      Response response = await authApiProvider.getCode(mobile);

      return DataSuccess(response.data["smsID"]);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> forgetPass(ForgetPasswordParams forgetPasswordParams) async {
    try {
       await authApiProvider.forgetPass(forgetPasswordParams);

      return DataSuccess("");
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }


}
