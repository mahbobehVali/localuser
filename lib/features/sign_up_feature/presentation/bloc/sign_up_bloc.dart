import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mahaliii/common/params/sign_up_params.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/features/sign_up_feature/domain/usecase/send_validation_code_usecase.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/region_status.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/register_status.dart';
import 'package:mahaliii/features/sign_up_feature/presentation/bloc/validation_status.dart';

import '../../../../common/params/change_alert_params.dart';
import '../../../../common/params/validation_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../../common/utils/use_case.dart';
import '../../../alert_feature/domain/entity/alert_type_entity.dart';
import '../../domain/entity/area_entity.dart';
import '../../domain/entity/region_entity.dart';
import '../../domain/usecase/area_usecase.dart';
import '../../domain/usecase/first_sign_up.dart';
import '../../domain/usecase/region_usecase.dart';
import '../../domain/usecase/register_usecase.dart';
import 'again_validation_status.dart';
import 'area_status.dart';
import 'first_level_status.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  RegisterUseCase registerUseCase;
  // AgainSendValidationCodeUseCase againSendValidationCodeUseCase;
  FirstSignupUseCase firstSignupUseCase;
  // ValidationUseCase validationUseCase;
  AreaUseCase areaUseCase;
  RegionUseCase regionUseCase;
  SendValidationCodeUseCase sendValidationCodeUseCase;
  SignUpBloc(
      this.registerUseCase,
      this.firstSignupUseCase,
      this.areaUseCase,
      this.regionUseCase,
      this.sendValidationCodeUseCase,

      ) : super(SignUpState(
      firstLevelSendStatus: FirstLevelInitial(),
      registerStatus: RegisterInitial(),
      signUpParams: SignUpParams(),
      mobile: "" ,
    areaStatus: AreaInitial(),
    regionStatus: RegionInitial(),
    oneRegionEntity: null,
    oneAreaEntity: null,
    ignoreArea: true,
    step: 0,
    serverId: "0",
      responsibilityList: Constants().responsibilityList,
    selectedResponsibility: null,
    againSendValidationStatus: AgainSendValidationInitial(),
    userValidationId: 0,
    sendValidationStatus: SendValidationInitial(),
    // responsibility: false,
    // region: false,
    // area: false,
    changeAlertParams: ChangeAlertParams()

  )) {

    on<FirstSignUpButtonClicked>((event, emit) async {
      emit(state.copyWith(
        newFirstLevelSendStatus: FirstLevelLoading(),
      ));

      DataState dataState = await firstSignupUseCase(event.signUpParams);

      if (dataState is DataSuccess) {
         // int serverId = dataState.data;
        emit(state.copyWith(
          newSignUpParams: event.signUpParams,
          newFirstLevelSendStatus: FirstLevelSuccess(),
          // newMobile: event.signUpParams.mobile,
          newStep: event.signUpParams.step,
          // newServerId: serverId

        ));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(
            newFirstLevelSendStatus:
            FirstLevelError(dataState.error!)));
      }
    });


    on<RegisterClicked>((event, emit) async {
      emit(state.copyWith(newRegisterStatus: RegisterLoading(),
        newStep: event.signUpParams.step,

      ));


      print("event.signUpParams.mobile${event.signUpParams.mobile}");
      DataState dataState = await firstSignupUseCase(SignUpParams(
        mobile: event.signUpParams.mobile,
        nationalCode: "100"
      ));

      if (dataState is DataSuccess) {
        // AuthEntity authEntity = dataState.data;
        ///save token
        // await locator<SharedPrefOperator>().setUserToken( "", dataState.data["type"] ?? 0);
      print("dataState.data${dataState.data}");
      final String smsId = dataState.data["smsID"].toString();

      emit(state.copyWith(
            newSignUpParams: event.signUpParams,
            newRegisterStatus: RegisterComplete(),
            newServerId: smsId
           ));
        // add(
        //   SaveServerId(
        //     event.signUpParams.copyWith(
        //         newServerId:dataState.data.serverId
        //     ),
        //   ),
        // );
      }
      if (dataState is DataFailed) {
        emit(
            state.copyWith(newRegisterStatus: RegisterError(dataState.error!)));
      }
    });

    on<SendValidation>((event, emit) async {
      emit(state.copyWith(newSendValidationStatus: SendValidationLoading(),

      ));
      DataState dataState = await registerUseCase(event.signUpParams);

      if (dataState is DataSuccess) {

        emit(state.copyWith(
            newSignUpParams: event.signUpParams,
            newSendValidationStatus: SendValidationSuccess(),
          ));
      }
      if (dataState is DataFailed) {
        emit(
            state.copyWith(newSendValidationStatus: SendValidationError(dataState.error!)));
      }
    });

    on<AgainSendValidationButtonClicked>((event, emit) async {
      print("state.signUpParams${state.signUpParams.mobile}");
      print("state.signUpParams${state.signUpParams.nationalCode}");
      emit(state.copyWith(newAgainSendValidationStatus: AgainSendValidationLoading()));
      DataState dataState = await firstSignupUseCase(SignUpParams(
        mobile: state.signUpParams.mobile,
        nationalCode: '100'
      ));

      if (dataState is DataSuccess) {
        print("dadadf${dataState.data}");

        emit(state.copyWith(
            newAgainSendValidationStatus: AgainSendValidationSuccess(dataState.data["smsID"]),
        newServerId: dataState.data["smsID"].toString()));
      }
      if (dataState is DataFailed) {
        emit(
            state.copyWith(newAgainSendValidationStatus: AgainSendValidationError(dataState.error!)));
      }
    });

    on<SaveServerId>((event, emit) async {
      emit(state.copyWith(newSignUpParams: event.signUpParams));


    });
  on<ChangeParams>((event, emit) async {
      emit(state.copyWith(newChangeAlertParams: event.changeAlertParams));


    });

    on<GetRegion>((event, emit) async {
      emit(state.copyWith(newRegionStatus: RegionLoading()));
      DataState dataState = await regionUseCase(NoParams());
      // ۱. چک کنید که اگر بلاک بسته شده، بقیه کد اجرا نشود
      if (isClosed) return;

      if (dataState is DataSuccess) {
        RegionEntity regionEntity=dataState.data[0];
        emit(state.copyWith(newRegionStatus: RegionSuccess(dataState.data),
            // newOneRegionEntity: regionEntity
        ));
        // ۲. خط ۱۰۹ را با این شرط بپوشانید
        // if (!isClosed) {
        //   add(GetArea(dataState.data[0].id!));
        // }
        //
        // add(GetArea(1));
      }
      if (dataState is DataFailed) {
        // ۳. اینجا هم چک کنید چون ممکن است در لحظه خطا هم بلاک بسته شده باشد
        if (!isClosed) {
          emit(state.copyWith(newRegionStatus: RegionError(dataState.error!)));
        }
      }    });

    on<OneRegionClicked>((event, emit) async {
      emit(state.copyWith(newOneRegionEntity: event.regionEntity,
          newChangeAlertParams: state.changeAlertParams.copyWith(newRegion: false)));
      add(GetArea(event.regionEntity.id!));
    });

    on<GetArea>((event, emit) async {
      emit(state.copyWith(newAreaStatus: AreaLoading()));
      DataState dataState = await areaUseCase(event.id);
      if (dataState is DataSuccess) {
        emit(state.copyWith(
          newAreaStatus: AreaSuccess(dataState.data),
          // newOneAreaEntity: dataState.data[0],
          // چون به طور خودکار ناحیه اول انتخاب شد، خطای ناحیه را false می‌کنیم
          // newChangeAlertParams: state.changeAlertParams.copyWith(newArea: false),
        ));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newAreaStatus: AreaError(dataState.error!)));
      }
    });

    on<OneAreaClicked>((event, emit) async {
      emit(state.copyWith(newOneAreaEntity: event.areaEntity,
          newChangeAlertParams: state.changeAlertParams.copyWith(newArea: false)));

    });

    on<ResponsibilityChanged>((event, emit) async {
      emit(state.copyWith(newSelectedResponsibility: event.responsibilityEntity.id,
          newChangeAlertParams: state.changeAlertParams.copyWith(newRes: false)));
    });

    on<FillUserValidationId>((event, emit) async {
      emit(state.copyWith(newUserValidationId: event.id));
    });
  }
}
