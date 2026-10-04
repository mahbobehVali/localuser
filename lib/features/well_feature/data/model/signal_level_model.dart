
import 'package:mahaliii/features/well_feature/domain/entity/signal_level_entity.dart';

class SignalLevelModel extends SignalLevelEntity {
  SignalLevelModel({
     int? signalLevel,
     String? title,
     int? wellId,
     int? deviceId,

  }) : super(signalLevel, title,wellId,deviceId);

  factory SignalLevelModel.fromJson(dynamic json) {

    return SignalLevelModel(
      signalLevel: json["signal_level"],
      title: json["title"],
      wellId: json["well_id"],
      deviceId: json["device_id"],

    );
  }

}



