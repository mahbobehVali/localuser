class SignUpParams {
  int? id;
  String? name;
  String? mobile;
  String? nationalCode;
  int? type;
  String? password;
  int? areaId;
  int? step;
  int? code;
  int? serverId;



  SignUpParams(
      {this.name,
        this.id,
        this.mobile,
        this.nationalCode,
        this.type,
        this.password,
        this.areaId,
        this.step,
        this.code,
        this.serverId,
      });

  SignUpParams copyWith(
      {String? newName,
        int? newId,
        String? newMobile,
        String? newNationalCode,
        int? newType,
        String? newPassword,
        int? newAreaId,
        int? newStep,
        int? newCode,
        int? newServerId,

      }) {
    return SignUpParams(
        name: newName ?? name,
        id: newId??id,
        mobile: newMobile ?? mobile,
        nationalCode: newNationalCode ?? nationalCode,
        type: newType ?? type,
        password: newPassword ?? password,
        areaId: newAreaId ?? areaId,
      step: newStep??step,
      code: newCode??code,
      serverId: newServerId??serverId

    );
  }
}
