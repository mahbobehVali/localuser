import 'package:equatable/equatable.dart';
import 'package:mahaliii/features/status_summary_feature/domain/entity/wells_data_entity.dart';

class WellsEntity extends Equatable{
  final int? areaId;
  final String? areaName;
  final WellsDataEntity? data;

  const WellsEntity( {this.areaId, this.areaName, this.data});

  @override
  // TODO: implement props
  List<Object?> get props => [areaId,areaName,data];
}
