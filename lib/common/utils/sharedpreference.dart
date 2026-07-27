
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth_feature/domain/entity/user_information_entity.dart';


class SharedPrefOperator {
  SharedPreferences sharedPreferences;
  SharedPrefOperator(this.sharedPreferences);

  ///save token
   Future<void> setUserToken(String token,UserInformationEntity userInformationEntity) async {

    sharedPreferences.setString("token", token);
    sharedPreferences.setBool("loggedIn", true);
    sharedPreferences.setStringList("userInformationEntity", [
      userInformationEntity.id.toString(),
      userInformationEntity.mobile??"",
      userInformationEntity.nationalCode??"",
      userInformationEntity.role.toString(),
      userInformationEntity.name??"",
      userInformationEntity.regionId.toString(),
      userInformationEntity.areaId.toString(),
      userInformationEntity.areaName??"",
      userInformationEntity.regionName??"",
      userInformationEntity.smsType.toString(),

    ]);
  }

  ///get token
  Future<List<dynamic>> getUserInformationEntity()  async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList("userInformationEntity") ?? [];
  }

  String getUserToken()  {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token") ?? "";
  }

  Future<void> saveAlertType(int type)  async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setInt("alert",type) ;
  }
  Future<int> getAlertTyp()  async {
    return sharedPreferences.getInt("alert")??0;
  }

  Future<void> saveAUserLocalId(int? userLocalId) async {
    if (userLocalId == null) {
      await sharedPreferences.remove("userLocalId");
    } else {
      await sharedPreferences.setInt("userLocalId", userLocalId);
    }
  }

// خروجی int? برمی‌گردونه تا نال بودن مشخص باشه
  Future<int?> getUserLocalId() async {
    return sharedPreferences.getInt("userLocalId");
  }



  Future<void> saveSwitch(bool value)  async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("switch",value) ;
  }



  // Future<bool> getSSwitch()  async {
  //   return sharedPreferences.getBool("switch")??false;
  // }

  //  changeTheme({String changeTheme = "light"}) async {
  //   sharedPreferences.setString("changeTheme", changeTheme);
  // }
  //
  //  getTheme({String changeTheme = "light"}) async {
  //   sharedPreferences.getString("changeTheme")??"light";
  // }

  // ///get Type
  //  Future<int?> signUpGetUserType() async {
  //
  //   return sharedPreferences.getInt("userType");
  // }

  ///set Type
  //  loginChangeUserType(int loginUserType ) async {
  //   sharedPreferences.setInt("loginUserType", loginUserType);
  // }

  ///get Type
  //  Future<int?> loginGetUserType() async {
  //
  //   return sharedPreferences.getInt("loginUserType")??0;
  // }



  ///save splashScreen is seen
  //  changeIntroState() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setBool("shouldShowIntro", false);
  // }
  //
  // ///check splashScreen is seen or not
  //  Future<bool> getIntroState() async {
  //
  //   return sharedPreferences.getBool("shouldShowIntro") ?? true;
  // }

  /// logout
   Future<void> logout() async {
    sharedPreferences.getString("token");
    sharedPreferences.remove("token");
    // sharedPreferences.clear();

  }


  // static getUserRefreshToken() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   return sharedPreferences.getString("refreshToken") ?? "";
  // }

  // static Future<bool> getLoggedIn() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   return sharedPreferences.getBool("loggedIn") ?? false;
  // }

  // static Future<void> changeTokenTemp() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var token = sharedPreferences.getString("token") ?? "";
  //   sharedPreferences.setString("token", token.replaceFirst("A", "f"));
  //   print("token changed");
  // }

  // static saveUserRefreshToken(String token, String refreshToken) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   sharedPreferences.setString("token", token);
  //   sharedPreferences.setString("refreshToken", refreshToken);
  // }
  //
  // static saveUserInformation(UpdateUserEntity updateUserEntity) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   sharedPreferences.setString("userProfileImage", updateUserEntity.result!.profileImage ?? "");
  //   sharedPreferences.setString("firstName", updateUserEntity.result!.firstName ?? "");
  //   sharedPreferences.setString("lastName", updateUserEntity.result!.lastName ?? "");
  //   sharedPreferences.setString("email", updateUserEntity.result!.email ?? "");
  //   sharedPreferences.setString("mobileNumber", updateUserEntity.result!.mobileNumber ?? "");
  //   sharedPreferences.setString("staticNumber", updateUserEntity.result!.phoneNumber ?? "");
  //   sharedPreferences.setString("nationalId", updateUserEntity.result!.nationalId ?? "");
  //   sharedPreferences.setString("provinceName", updateUserEntity.result!.provinceName ?? "");
  //   sharedPreferences.setString("address", updateUserEntity.result!.address ?? "");
  //   sharedPreferences.setString("postalCode", updateUserEntity.result!.postalCode ?? "");
  //   sharedPreferences.setBool("dataIsUpdated", true);
  // }

  // static saveUserInformationInFetch(UserInfoEntity updateUserEntity) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   sharedPreferences.setString("userProfileImage", updateUserEntity.result!.profileImage ?? "");
  //   sharedPreferences.setString("firstName", updateUserEntity.result!.firstName ?? "");
  //   sharedPreferences.setString("lastName", updateUserEntity.result!.lastName ?? "");
  //   sharedPreferences.setString("email", updateUserEntity.result!.email ?? "");
  //   sharedPreferences.setString("mobileNumber", updateUserEntity.result!.mobileNumber ?? "");
  //   sharedPreferences.setString("staticNumber", updateUserEntity.result!.phoneNumber ?? "");
  //   sharedPreferences.setString("nationalId", updateUserEntity.result!.nationalId ?? "");
  //   sharedPreferences.setString("provinceName", updateUserEntity.result!.provinceName ?? "");
  //   sharedPreferences.setString("address", updateUserEntity.result!.addressLine ?? "");
  //   // sharedPreferences.setString("postalCode", updateUserEntity.result!.po ?? "");
  // }
  //
  // static Future<UserInfoParam> getUserInformation() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   return UserInfoParam(
  //     profileImage: sharedPreferences.getString("userProfileImage") ?? "",
  //     firstName: sharedPreferences.getString("firstName") ?? "",
  //     lastName: sharedPreferences.getString("lastName") ?? "",
  //     email: sharedPreferences.getString("email") ?? "",
  //     mobileNumber: sharedPreferences.getString("mobileNumber") ?? "",
  //     staticNumber: sharedPreferences.getString("staticNumber") ?? "",
  //     nationalId: sharedPreferences.getString("nationalId") ?? "",
  //     provinceName: sharedPreferences.getString("provinceName") ?? "",
  //     address: sharedPreferences.getString("address") ?? "",
  //     postalCode: sharedPreferences.getString("postalCode") ?? "",
  //   );
  // }

  // static Future<bool> getDataIsUpdated() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   return sharedPreferences.getBool("dataIsUpdated") ?? false;
  // }

}