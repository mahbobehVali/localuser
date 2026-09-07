part of 'sign_up_bloc.dart';

class SignUpState {
  ///consultant firstLevel
  final FirstLevelSendStatus? firstLevelSendStatus;

  ///all params for register
  final SignUpParams signUpParams;


  // final ThirdLevelStartStatus? thirdLevelStartStatus;

  ///a class with id and title for dropDownButton for selecting teacher
  // final List<TeacherModel> teacherModel;

  ///is teacher or not
  // final int selectedTeacher;

  final RegisterStatus? registerStatus;
  final String? mobile;
  AreaStatus areaStatus;
  RegionStatus regionStatus;
  final AreaEntity? oneAreaEntity;
  final RegionEntity? oneRegionEntity;
  final bool ignoreArea;
  final int? step;
  final int? serverId;
  final List<AlertTypeEntity> responsibilityList;
  final int? selectedResponsibility;
  final AgainSendValidationStatus? againSendValidationStatus;
  final int userValidationId;
  final SendValidationStatus sendValidationStatus;
  // final bool responsibility;
  // final bool region;
  // final bool area;
  final ChangeAlertParams changeAlertParams;




  SignUpState({
    required this.firstLevelSendStatus,
    required this.registerStatus,
    required this.signUpParams,
    required this.mobile,
    required this.areaStatus,
    required this.regionStatus,
    required this.oneAreaEntity,
    required this.oneRegionEntity,
    required this.ignoreArea,
    required this.step,
    required this.serverId,
    required this.responsibilityList,
    required this.selectedResponsibility,
    required this.againSendValidationStatus,
    required this.userValidationId,
    required this.sendValidationStatus,
    // required this.responsibility,
    // required this.region,
    // required this.area,
    required this.changeAlertParams,
  });

  SignUpState copyWith(
      {
        FirstLevelSendStatus? newFirstLevelSendStatus,
        String? newName,
        String? newMobile,
        String? newNationalCode,
        // List<TeacherModel>? newTeachers,
        // int? newSelectedTeacher,
        SignUpParams? newSignUpParams,
        RegisterStatus? newRegisterStatus,
        AreaStatus? newAreaStatus,
        RegionStatus? newRegionStatus,
         AreaEntity? newOneAreaEntity,
         RegionEntity? newOneRegionEntity,
         bool? newIgnoreArea,
        int? newStep,
        int? newServerId,
         List<AlertTypeEntity>? newResponsibilityList,
        int? newSelectedResponsibility,
        AgainSendValidationStatus? newAgainSendValidationStatus,
        int? newUserValidationId,
        SendValidationStatus? newSendValidationStatus,
         // bool? newResponsibility,
         // bool? newRegion,
         // bool? newArea,
        ChangeAlertParams? newChangeAlertParams




      }) {
    return SignUpState(
        firstLevelSendStatus:
        newFirstLevelSendStatus ?? firstLevelSendStatus,

        // teacherModel: newTeachers ?? teacherModel,
        // selectedTeacher: newSelectedTeacher ?? selectedTeacher,

        registerStatus: newRegisterStatus ?? registerStatus,
        signUpParams:
        newSignUpParams ?? signUpParams,
      mobile: newMobile??mobile,
      areaStatus: newAreaStatus??areaStatus,
      regionStatus: newRegionStatus??regionStatus,
      oneAreaEntity: newOneAreaEntity??oneAreaEntity,
      oneRegionEntity: newOneRegionEntity??oneRegionEntity,
      ignoreArea: newIgnoreArea??ignoreArea,
      step: newStep??step, serverId: newServerId??serverId,
      responsibilityList: newResponsibilityList??responsibilityList,
      selectedResponsibility: newSelectedResponsibility??selectedResponsibility,
      againSendValidationStatus: newAgainSendValidationStatus??againSendValidationStatus,
      userValidationId: newUserValidationId??userValidationId,
      sendValidationStatus: newSendValidationStatus??sendValidationStatus,
      // responsibility: newResponsibility??responsibility,
      // region: newRegion??region,
      // area: newArea??area,
      changeAlertParams: newChangeAlertParams ?? this.changeAlertParams,
    );
  }
}
