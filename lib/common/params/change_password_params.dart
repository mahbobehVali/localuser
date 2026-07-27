

class ChangePasswordParams{
  int? code;
  int? serverId;
  String? oldPassword;
  String? newPassword;
  ChangePasswordParams(
      {this.code, this.serverId,this.oldPassword,this.newPassword });

}