
import 'package:mahaliii/features/report_feature/domain/entity/capacity_list_entity.dart';

class CapacityEntity {

   final List<CapacityListEntity>? capacityListEntity;
   final int? totalCapacity;
   final int? totalDisconnectCapacity;
    CapacityEntity( this.capacityListEntity,this.totalCapacity,this.totalDisconnectCapacity);
}
