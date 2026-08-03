part of 'support_bloc.dart';

sealed class SupportEvent extends Equatable {
  const SupportEvent();
}

class GetSupportMessage extends SupportEvent{
  FlowMeterParams flowMeterParams;

  GetSupportMessage(this.flowMeterParams);

  @override
  // TODO: implement props
  List<Object?> get props => [flowMeterParams];

}

class OneSupportStatusClicked extends SupportEvent{
  final AlertTypeEntity status;

  OneSupportStatusClicked(this.status);

  @override
  // TODO: implement props
  List<Object?> get props => [status];

}


class GetSupportAnswers extends SupportEvent{
  final int id;

  GetSupportAnswers(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];

}

class SendNewSupportClicked extends SupportEvent {
  SendNewSupportParams sendNewRequestToSupportParams;

  SendNewSupportClicked(this.sendNewRequestToSupportParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SendAnswer extends SupportEvent {
  SendNewSupportParams sendNewRequestToSupportParams;

  SendAnswer(this.sendNewRequestToSupportParams);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddSupportFileClicked extends SupportEvent {


  const AddSupportFileClicked();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddSupportImageClicked extends SupportEvent {


  const AddSupportImageClicked();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeAnswer extends SupportEvent {
   bool answer;


   ChangeAnswer(this.answer);

  @override
  // TODO: implement props
  List<Object?> get props => [answer];
}

class SupportClose extends SupportEvent {
  int id;

  SupportClose(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

