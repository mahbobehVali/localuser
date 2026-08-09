import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahaliii/common/params/flowmeter_params.dart';
import 'package:mahaliii/common/utils/constants.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/send_answer_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/send_support_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_answers_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_close_usecase.dart';
import 'package:mahaliii/features/support_feature/domain/usecase/support_usecase.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/send_answer_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/send_support_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_answers_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_close_status.dart';
import 'package:mahaliii/features/support_feature/presentation/bloc/support_status.dart';

import '../../../../common/params/send_new_request_to_support_params.dart';
import '../../../../common/utils/data_state.dart';
import '../../../alert_feature/domain/entity/alert_type_entity.dart';

part 'support_event.dart';
part 'support_state.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportUseCase supportUseCase;
  SupportAnswersUseCase supportAnswersUseCase;
  SendSupportUseCase sendSupportUseCase;
  SendAnswerUseCase sendAnswer;
  SupportCloseUseCase supportCloseUseCase;
  SupportBloc(this.supportUseCase,this.supportAnswersUseCase,this.sendSupportUseCase,this.sendAnswer,this.supportCloseUseCase) : super(SupportState(
    supportStatus: SupportInitial(),
    selectedSupportPage: 1,
    selectedSupportStatus: 0,
    supportStatusList: Constants().supportStatus,
    supportAnswersStatus: SupportAnswersInitial(),
    sendSupportStatus: SendSupportInitial(),
      supportFile:"",
      overImage: false,
    answer: false,
    sendAnswerStatus: SendAnswerInitial(),
    supportCloseStatus: SupportCloseInitial()
  )) {
    on<GetSupportMessage>((event, emit) async {
      emit(state.copyWith(newSupportStatus: SupportLoading(),newSelectedSupportPage: event.flowMeterParams.page));

      DataState dataState = await supportUseCase(event.flowMeterParams);

      if (dataState is DataSuccess) {
        if(dataState.data.data.isEmpty){
          emit(state.copyWith(newSupportStatus: SupportEmpty()));

        }else{
          emit(state.copyWith(newSupportStatus: SupportSuccess(dataState.data)));

        }

      }
      if (dataState is DataFailed) {
        if (dataState.isTokenExpired) {
          emit(state.copyWith(newSupportStatus: SupportExit()));
        }else {
          emit(
              state.copyWith(newSupportStatus: SupportError(dataState.error!)));
        }
      }    });

    on<OneSupportStatusClicked>((event, emit) async {
      emit(state.copyWith(newSelectedSupportStatus: event.status.id));
      add(GetSupportMessage(FlowMeterParams(
        status: event.status.id,
        page: 1,

      )));


    });
    on<GetSupportAnswers>((event, emit) async {
      emit(state.copyWith(newSupportAnswersStatus: SupportAnswersLoading(),
      ));

      DataState dataState = await supportAnswersUseCase(event.id);

      if (dataState is DataSuccess) {
        if(dataState.data.support.isEmpty){
          emit(state.copyWith(newSupportAnswersStatus: SupportAnswersEmpty()));

        }else{
          emit(state.copyWith(newSupportAnswersStatus: SupportAnswersSuccess(dataState.data)));

        }

      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newSupportAnswersStatus: SupportAnswersError(dataState.error!)));

      }    });

    on<AddSupportFileClicked>((event, emit) async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file=File(result.files.single.path??"");

        PlatformFile pickedFile = result.files.first;
        int? fileSizeInBytes = pickedFile.size;
        emit(state.copyWith(newSupportFile: (fileSizeInBytes > Constants.MAX_FILE_SIZE_BYTES)?null:file.path,
            newOverImage: (fileSizeInBytes > Constants.MAX_FILE_SIZE_BYTES)?true:false));
      }
    });
    on<AddSupportImageClicked>((event, emit) async {
      final imagePicker = ImagePicker();

      XFile? xFile = await imagePicker.pickImage(
          source: ImageSource.camera);

      if (xFile != null) {
        File file=File(xFile.path);
        int fileSizeInBytes=await file.length();

        // CroppedFile? croppedFile=await ImageCropper().cropImage(sourcePath:
        // xFile.path,
        //     maxHeight: 200,
        //     maxWidth: 200,
        //     aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        //     uiSettings: [
        //       AndroidUiSettings(cropStyle:CropStyle.circle,
        //           toolbarTitle: "crop image"),
        //       IOSUiSettings(cropStyle:CropStyle.circle,
        //           title: "crop image")
        //     ]
        // );
        emit(state.copyWith(newSupportFile: (fileSizeInBytes > Constants.MAX_FILE_SIZE_BYTES)?null:file.path,
            newOverImage: (fileSizeInBytes > Constants.MAX_FILE_SIZE_BYTES)?true:false));

      }
    });

    on<SendNewSupportClicked>((event, emit) async {
      emit(state.copyWith(newSendSupportStatus: SendSupportLoading(),newSelectedSupportStatus: event.sendNewRequestToSupportParams.status));
      DataState dataState =
      await sendSupportUseCase(event.sendNewRequestToSupportParams);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newSendSupportStatus: const SendSupportSuccess()));
        add( GetSupportMessage(FlowMeterParams(page: 1,status: event.sendNewRequestToSupportParams.status)));


      }
      if (dataState is DataFailed) {
        emit(state.copyWith(
            newSendSupportStatus: SendSupportError(dataState.error!)));
      }
    });

    on<SendAnswer>((event, emit) async {
      emit(state.copyWith(newSendAnswerStatus: SendAnswerLoading()));
      DataState dataState =
      await sendAnswer(event.sendNewRequestToSupportParams);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newSendAnswerStatus: const SendAnswerSuccess()));
        add(GetSupportAnswers(event.sendNewRequestToSupportParams.id!));

      }
      if (dataState is DataFailed) {
        emit(state.copyWith(
            newSendAnswerStatus: SendAnswerError(dataState.error!)));
      }
    });


    on<ChangeAnswer>((event, emit) async {
      emit(state.copyWith(newAnswer: event.answer));

    });

    on<SupportClose>((event, emit) async {
      emit(state.copyWith(newSupportCloseStatus: SupportCloseLoading()));
      DataState dataState =
      await supportCloseUseCase(event.id);
      if (dataState is DataSuccess) {
        emit(state.copyWith(newSupportCloseStatus: const SupportCloseSuccess()));

      }
      if (dataState is DataFailed) {
        emit(state.copyWith(
            newSupportCloseStatus: SupportCloseError(dataState.error!)));
      }
    });

  }
}
