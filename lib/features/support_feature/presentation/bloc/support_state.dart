part of 'support_bloc.dart';


class SupportState {

  final SupportStatus supportStatus;
  final int selectedSupportPage;
  final int selectedSupportStatus;
  final List<AlertTypeEntity> supportStatusList;
  final SupportAnswersStatus supportAnswersStatus;
  final SendSupportStatus sendSupportStatus;
  final String supportFile;
  final bool overImage;
   bool answer;
  final SendAnswerStatus sendAnswerStatus;
  final SupportCloseStatus supportCloseStatus;

  SupportState({

    required this.supportStatus,
    required this.selectedSupportPage,
    required this.selectedSupportStatus,
    required this.supportStatusList,
    required this.supportAnswersStatus,
    required this.sendSupportStatus,
    required this.supportFile,
    required this.overImage,
    required this.answer,
    required this.sendAnswerStatus,
    required this.supportCloseStatus,
  });

  SupportState copyWith(
      {
        SupportStatus? newSupportStatus,
        int? newSelectedSupportPage,
        int? newSelectedSupportStatus,
        List<AlertTypeEntity>? newSupportStatusList,
        SupportAnswersStatus? newSupportAnswersStatus,
        SendSupportStatus? newSendSupportStatus,
        String? newSupportFile,
        bool? newOverImage,
        bool? newAnswer,
        SendAnswerStatus? newSendAnswerStatus,
        SupportCloseStatus? newSupportCloseStatus

      }) {
    return SupportState(
        supportStatus: newSupportStatus??supportStatus,
      selectedSupportPage: newSelectedSupportPage??selectedSupportPage,
      selectedSupportStatus: newSelectedSupportStatus??selectedSupportStatus,
      supportStatusList: newSupportStatusList??supportStatusList,
      supportAnswersStatus: newSupportAnswersStatus??supportAnswersStatus,
      sendSupportStatus: newSendSupportStatus??sendSupportStatus,
      supportFile: newSupportFile??supportFile,
      overImage: newOverImage??overImage,
      answer: newAnswer??answer,
      sendAnswerStatus: newSendAnswerStatus??sendAnswerStatus,
      supportCloseStatus: newSupportCloseStatus??supportCloseStatus


    );
  }
}

