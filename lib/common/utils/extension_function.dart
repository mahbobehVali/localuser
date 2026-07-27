import 'package:intl/intl.dart';

  extension LabelAndFormatInt on int {
  //123456 ->   123,456 تومان
  String labelInt() => "$separatedByCommaInt تومان";

  // 123456 -> 123,456
  String get separatedByCommaInt {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

extension LabelAndFormatDouble on double {
  //123456 ->   123,456 تومان
  String labelDouble() => "$separatedByCommaDouble تومان";

  // 123456 -> 123,456
  String get separatedByCommaDouble {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

extension LabelString on String {
  String conInt() => convertInt;

  String get convertInt {
    final numberFormat = NumberFormat.decimalPattern();
    var number = int.parse(this);
    return numberFormat.format(number);
  }
}

  extension LabelAndFormatString on String {
  //"123456" ->   123,456 تومان
  String labelString() => "$separatedByCommaString تومان";

  // "123456" -> 123,456
  String get separatedByCommaString {
    final numberFormat = NumberFormat.decimalPattern();
    int number = int.parse(this);
    return numberFormat.format(number);
  }
}


extension DurationExtension on Duration{
    String toHoursMinutes(){
      String twoDigitMinutes=_toTwoDigits(inMinutes.remainder(60));
      return "${_toTwoDigits(inHours)}:$twoDigitMinutes";

    }

    // String toHoursMinutesSeconds(){
    //   String twoDigitMinutes=_toTwoDigits(inMinutes.remainder(60));
    //   String twoDigitSeconds=_toTwoDigits(inSeconds.remainder(60));
    //   return "${_toTwoDigits(inHours)}:$twoDigitSeconds";
    //
    // }
    //
    // String toMinutesSeconds(){
    //   String twoDigitMinutes=_toTwoDigits(inMinutes.remainder(60));
    //   String twoDigitSeconds=_toTwoDigits(inSeconds.remainder(60));
    //   return "${_toTwoDigits(inHours)}:$twoDigitSeconds";
    //
    // }

    String _toTwoDigits(int n){
      if(n>=10) {
        return "$n";
      }
      return "0$n";
    }
}


// extension DurationExtension on Duration {
//   String toMinutesSeconds() {
//     String twoDigits(int n) {
//       if (n >= 10) return "$n";
//       return "0$n";
//     }
//
//     String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
//     if (inHours > 0) {
//       String twoDigitHours = twoDigits(inHours);
//       return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
//     } else {
//       return "$twoDigitMinutes:$twoDigitSeconds";
//     }
//   }
// }
