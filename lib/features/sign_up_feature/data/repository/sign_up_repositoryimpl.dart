import 'package:dio/dio.dart';

import '../../../../common/error_handling/check_exceptions.dart';
import '../../../../common/error_handling/exceptions.dart';
import '../../../../common/params/sign_up_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../domain/entity/area_entity.dart';
import '../../domain/entity/region_entity.dart';
import '../../domain/repository/sign_up_repository.dart';
import '../datasource/remote/sign_up_api_provider.dart';
import '../model/area_model.dart';
import '../model/region_model.dart';

class SignUpRepositoryImpl extends SignUpRepository {
  final SignUpApiProvider apiProvider;
  // static ValueNotifier<AuthEntity?> authNotifier = ValueNotifier(null);

  SignUpRepositoryImpl({required this.apiProvider});

  @override
  Future<DataState<dynamic>> firstSignUp(firstLevelSignInParams) async {
    try {
      Response response = await apiProvider.firstSignUp(firstLevelSignInParams);

      return DataSuccess(response.data["smsID"]);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> getValidationCode(SignUpParams signUpParams) async {
    try {
      await apiProvider.getValidationCode(signUpParams);

      return DataSuccess("");
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState> register(signUpParams) async {
    try {
      Response response = await apiProvider.register(signUpParams);
      // AuthEntity authEntity = AuthModel.fromJson(response.data);

      return DataSuccess(response.data);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState<dynamic>> getRegions() async {
    try {
      Response response = await apiProvider.getRegions();
      List<RegionEntity> regionEntity=[];
      for (var element in (response.data as List)) {
        regionEntity.add(RegionModel.fromJson(element));
      }

      return DataSuccess(regionEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

  @override
  Future<DataState> getArea(id) async {
    try {
      Response response = await apiProvider.getArea(id);
      List<AreaEntity> areaEntity=[];
      for (var element in (response.data as List)) {
        areaEntity.add(AreaModel.fromJson(element));
      }

      return DataSuccess(areaEntity);
    } on AppException catch (e) {
      return CheckExceptions.getError(e);
    }
  }

}
