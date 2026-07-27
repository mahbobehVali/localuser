
import 'package:equatable/equatable.dart';

import '../../../domain/entity/program_day_entity.dart';


abstract class GetProgramStatus extends Equatable {
  const GetProgramStatus();
}

class GetProgramLoading extends GetProgramStatus {
  @override
  List<Object> get props => [];
}

class GetProgramReLoading extends GetProgramStatus {
  @override
  List<Object> get props => [];
}

class GetProgramInitial extends GetProgramStatus {
  @override
  List<Object> get props => [];
}

class GetProgramError extends GetProgramStatus {
  final String error;

  const GetProgramError(this.error);

  @override
  List<Object> get props => [error];
}

class GetProgramSuccess extends GetProgramStatus {
  final List<ProgramDayEntity> programDayEntity;
  const GetProgramSuccess({required this.programDayEntity});


  @override
  // TODO: implement props
  List<Object?> get props =>[programDayEntity];
}
