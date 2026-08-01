
import 'package:mahaliii/features/report_feature/domain/entity/capacity_list_entity.dart';

class SupportDataEntity {
  // "payvast": "file-1785158272521-623217533.jpg",

   final int? id;
   final int? part;
   final int? status;
   final String? subject;
   final String? description;
   final String? date;
   final String? clock;
    SupportDataEntity( this.id,this.part,
        this.status,this.subject,this.description,this.date,this.clock);
}
