
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
  Future<void> saveSwitch(bool value)  async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setBool("switch",value) ;
  }
  Future<bool> getSwitch()  async {
    return sharedPreferences.getBool("switch")??false;
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


  /// logout
  Future<bool> logout() async {
    await sharedPreferences.remove("userLocalId");
    await sharedPreferences.remove("loggedIn");
    await sharedPreferences.remove("userInformationEntity");
    return await sharedPreferences.remove("token"); // 🔑 پاک‌سازی کامل توکن
  }

  // static Future<void> changeTokenTemp() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   var token = sharedPreferences.getString("token") ?? "";
  //   sharedPreferences.setString("token", token.replaceFirst("A", "f"));
  //   print("token changed");
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


}