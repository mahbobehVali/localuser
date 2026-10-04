library;

import 'package:mahaliii/features/auth_feature/data/model/user_information_model.dart';

import '../../domain/entity/account_entity.dart';

class AuthModel extends AuthEntity {
  AuthModel({
    String? accessToken,
    UserInformationModel? userInformation
  }) : super(accessToken,userInformation);

  factory AuthModel.fromJson(dynamic json) {

    return AuthModel(
      accessToken: json["access_token"]??"",
      userInformation: UserInformationModel.fromJson(json["user"])

    );
  }
}
