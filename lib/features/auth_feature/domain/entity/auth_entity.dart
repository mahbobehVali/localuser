
import 'package:mahaliii/features/auth_feature/domain/entity/user_information_entity.dart';

class AuthEntity {
  final String? accessToken;
   final UserInformationEntity? userInformation;

  AuthEntity(this.accessToken,this.userInformation);
}
