

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mahaliii/features/alert_feature/domain/entity/alert_type_entity.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../config/color_palette.dart';

// enum FilterType { region, area, alertStatus, alertType }

// enum DropdownType { flowMeter, pressure, temperature }


class Constants {
  // static String baseUrl="http://192.168.120.108:8000/";
  static String baseUrl = "https://www.abyarinovin.ir/api/";
  static const int MAX_FILE_SIZE_BYTES = 1048576;


  static bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static bool isPasswordValid(String password) {
    // این ریجکس حداقل یک حرف بزرگ، یک کوچک، یک عدد و «هر» کاراکتر خاصی (مثل #) را قبول می‌کند
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^A-Za-z0-9]).+$'
    );

    return passwordRegex.hasMatch(password);
  }


  static Widget noData(){
    return Padding(
      padding: EdgeInsets.all(32),
      child: Center(child: Text("داده ای وجود ندارد")),
    );
  }


  // static bool isValidEmail(String email) {
  //   if(email.isEmpty) {
  //     return true;
  //   }
  //   final emailRegExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
  //   return emailRegExp.hasMatch(email);
  // }

  final monthNames = [
    'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
    'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
  ];
  final weekDayNames = [
    AlertTypeEntity("شنبه", 6),
    AlertTypeEntity("یکشنبه", 0),
    AlertTypeEntity("دوشنبه", 1),
    AlertTypeEntity("سه شنبه", 2),
    AlertTypeEntity("چهارشنبه", 3),
    AlertTypeEntity("پنج شنبه", 4),
    AlertTypeEntity("جمعه", 5),
  ];

  final List<Color> lineColors = [
    ColorPalette.darkRed,
    ColorPalette.darkBlue,
    ColorPalette.darkGreen,
    ColorPalette.lightGreen,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.pinkAccent,
  ];

  List<dynamic> alert = [
    {
      "title":"پیامک",
      "id":0

    },
    {
      "title": "تلفن",
      "id": 1
    },
    {
      "title": "هردو",
      "id": 2
    }

  ];


  List<dynamic> alertCrete = [
    {
      "title":"در حال بررسی",
      "status":1

    },
    {
      "title": "رفع شده",
      "status": 2
    }

  ];

  List<dynamic> rowSupport = [
    {
      "title":"پشتیبانی دستگاه",
      "icon":Icon(Icons.contact_support_outlined),
      "part":5

    },
    {
      "title": "درخواست به مدیر",
      "icon":Icon(Icons.contact_support_outlined),
      "part":1

    },


  ];

  List<String> waterVolume = [
    "حجم کل آب مصرف شده",
    "مجموع ساعات کارکرد پمپ ها",
    "تعداد هشدارهای صادر شده",
  ];

  List<String> signUpConstant=[

    "اطلاعات هویتی",
    "پیامک تایید",
    "اطلاعات تکمیلی",

  ];


  List<AlertTypeEntity> alertType = [
    AlertTypeEntity("نشتی آب", 0),
    AlertTypeEntity("برگشتی آب", 1),
    AlertTypeEntity("روشن شدن غیر مجاز", 2),
    AlertTypeEntity("روشن نشدن پمپ", 3),
    AlertTypeEntity("قطعی برق", 4),
    AlertTypeEntity("اتمام باتری", 5),
    AlertTypeEntity("عدم دریافت اطلاعات", 6),
    AlertTypeEntity("مصرف غیر مجاز", 7),
    AlertTypeEntity("اتمام خدمت", 8),

  ];


  List<AlertTypeEntity> alertStatus = [
    AlertTypeEntity("جدید", 0),
    AlertTypeEntity("در انتظار بررسی", 1),
    AlertTypeEntity("پاسخ داده شده", 2),

  ];

  List<AlertTypeEntity> supportStatus = [
    AlertTypeEntity("جدید", 0),
    AlertTypeEntity("در حال بررسی", 1),
    AlertTypeEntity("پاسخ داده شده", 2),
    AlertTypeEntity("بسته شده", 3),

  ];

  List<AlertTypeEntity> reportIndex = [
    AlertTypeEntity("نمودار مصرف کل", 0),
    AlertTypeEntity("نمودار جزئیات مصرف", 1),
    AlertTypeEntity("نمودار عملکرد پمپ", 2),
    AlertTypeEntity("نمودار هشدارها", 3),
    AlertTypeEntity("دسترسی کاربران", 4),

  ];

  BoxDecoration boxDecoration=BoxDecoration(
      borderRadius: BorderRadius.only(bottomRight:Radius.circular(5),
          topRight: Radius.circular(5)),
      color: ColorPalette.lightGrey
  );

  BoxDecoration whiteFiveRadiusDecoration=BoxDecoration(
      color: ColorPalette.white,
      borderRadius: BorderRadius.circular(5)
  );

  Map<String, double> getChartScale(List<dynamic> values1, [List<dynamic>? values2]) {
    // اگر لیست دوم نال بود، یک لیست خالی در نظر گرفته می‌شود
    List<dynamic> combinedValues = [...values1, ...(values2 ?? [])];

    if (combinedValues.isEmpty) {
      return {'step': 100.0, 'maxY': 100.0, 'minY': 0.0};
    }

    // ۱. یک‌بار برای همیشه همه مقادیر را به double معتبر تبدیل کن
    final List<double> cleanValues = combinedValues
        .map((e) => double.tryParse(e.toString()) ?? 0.0)
        .toList();

    // ۲. حالا خیلی راحت و بدون خطا از لیست عددی استفاده کن
    double maxVal = cleanValues.reduce((a, b) => a > b ? a : b);
    double minVal = cleanValues.reduce((a, b) => a < b ? a : b);

    // محاسبه بزرگترین قدر مطلق به صورت کاملا ایمن
    double maxAbs = cleanValues.map((e) => e.abs()).reduce((a, b) => a > b ? a : b);

    // ۱. تعیین فاصله (Step)
    double step;
    if (maxAbs > 40000) {
      step = 20000.0;
    } else if (maxAbs > 10000) {
      step = 5000.0;
    } else if (maxAbs > 1000) {
      step = 500.0;
    } else if (maxAbs > 500) {
      step = 150.0;
    } else if (maxAbs > 100) {
      step = 50.0;
    } else if (maxAbs > 50) {
      step = 20.0;
    } else if (maxAbs > 30) {
      step = 10.0;
    } else if (maxAbs > 10) {
      step = 5.0;
    } else if (maxAbs > 5) {
      step = 2.0;
    } else {
      step = 1.0;
    }

    // ۲. محاسبه سقف
    double finalMaxY = (maxVal / step).ceil() * step;

    // ۳. محاسبه کف
    double finalMinY;
    if (minVal < 0) {
      finalMinY = (minVal / step).floor() * step;
    } else {
      finalMinY = 0.0;
    }

    // جلوگیری از خطای هم‌سان بودن سقف و کف
    if (finalMaxY <= finalMinY) finalMaxY = finalMinY + step;

    return {
      'step': step,
      'maxY': finalMaxY,
      'minY': finalMinY,
    };
  }

  Map<String, double> getScale(List<dynamic> allValues) {
    if (allValues.isEmpty) {
      return {'step': 100.0, 'maxY': 100.0, 'minY': 0.0};
    }

    // ۱. یک‌بار برای همیشه همه مقادیر را به double معتبر تبدیل کن
    final List<double> cleanValues = allValues
        .map((e) => double.tryParse(e.toString()) ?? 0.0)
        .toList();

    // ۲. حالا خیلی راحت و بدون خطا از لیست عددی استفاده کن
    double maxVal = cleanValues.reduce((a, b) => a > b ? a : b);
    double minVal = cleanValues.reduce((a, b) => a < b ? a : b);

    // محاسبه بزرگترین قدر مطلق به صورت کاملا ایمن
    double maxAbs = cleanValues.map((e) => e.abs()).reduce((a, b) => a > b ? a : b);

    // ۳. تعیین فاصله (Step) هوشمندتر
    double step;
    if (maxAbs > 40000) {
      step = 20000.0;
    } else if (maxAbs > 10000) {
      step = 5000.0;
    } else if (maxAbs > 1000) {
      step = 500.0;
    } else if (maxAbs > 500) {
      step = 150.0;
    } else if (maxAbs > 100) {
      step = 50.0;
    } else if (maxAbs > 50) {
      step = 20.0;
    } else if (maxAbs > 30) {
      step = 10.0;
    } else if (maxAbs > 10) {
      step = 5.0;
    } else {
      step = 2.0;
    }

    // ۴. محاسبه سقف و کف به صورت کاملاً ایمن
    double finalMaxY = (maxVal / step).ceil() * step;

    //  اصلاح طلایی اینجاست:
    // ابتدا با فرمول مقدار را حساب می‌کنیم
    double finalMinY = (minVal / step).floor() * step;

    // اگر تمام داده‌های ورودی مثبت یا صفر هستند (یعنی هیچ مقدار منفی در دیتابیس نداریم)
    // حتماً کف را روی صفر قفل کن تا خطای فلو کِفِ نمودار را منفی نکند
    if (minVal >= 0) {
      finalMinY = 0.0;
    }

    if (maxVal <= 0 && finalMaxY < 0) {
      finalMaxY = 0.0;
    }

    if (finalMaxY <= finalMinY) {
      finalMaxY = finalMinY + step;
    }

    return {
      'step': step,
      'maxY': finalMaxY,
      'minY': finalMinY,
    };
  }

  Widget bottomTitles(
      double value,
      TitleMeta meta,
      List<dynamic> customTitles,
      String day,
      ) {
    final int index = value.toInt();

    // ۱. کنترل محدوده اندیس
    if (index < 0 || index >= customTitles.length) {
      return const SizedBox();
    }

    final dynamic rawData = customTitles[index];
    final String titleString = rawData?.toString() ?? '';

    String displayText = '';

    // ۲. پردازش بر اساس حالت انتخاب شده (با کنترل خطای Index)
    if (day == "day") {
      // استفاده از RegExp برای پشتیبانی از انواع فاصله‌ها
      final parts = titleString.trim().split(RegExp(r'\s+'));
      // اگر بخش دوم وجود داشت اونو بردار، وگرنه کل رشته رو نشون بده
      displayText = parts.length > 1 ? parts[1] : parts[0];
    }
    else if (day == "clock") {
      displayText = titleString;
    }
    else if (day == "date") {
      final parts = titleString.split('/');
      // اگر ۳ بخش داشت (سال/ماه/روز)، روز (اندیس 2) رو بردار
      displayText = parts.length > 2 ? parts[2] : titleString;
    }
    else if (day == "week") {
      displayText = (index < Constants().weekDayNames.length)
          ? Constants().weekDayNames[index].name
          : titleString;
    }
    else {
      displayText = titleString;
    }


    final Widget text = Transform.rotate(
      angle: -20 * math.pi / 180,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Text(
          displayText.toPersianDigit(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );

    return SideTitleWidget(
      fitInside: const SideTitleFitInsideData(
        enabled: true,
        axisPosition: 0,
        parentAxisSize: 0,
        distanceFromEdge: 0,
      ),
      meta: meta,
      space: 16,
      child: text,
    );
  }

  AxisTitles leftTitles({required double scale, required double interval}) {
    return AxisTitles(

      sideTitles: SideTitles(
        showTitles: true,
        interval:scale ,
        reservedSize: interval,
        getTitlesWidget: (value, meta) {

          return Padding(
            padding: const EdgeInsets.all(3),
            child: Text(value.toInt().toString().toPersianDigit(),
                ),
          );
        },
      ),
    );
  }

  AxisTitles axisBottomTitles(List<dynamic> xLabels,String selected) {
    return  AxisTitles(
      sideTitles: SideTitles(
        interval: 1,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (value < 0 || value >= xLabels.length || value % 1 != 0) {
            return const SizedBox();
          }
          return Constants().bottomTitles(value, meta, xLabels,selected);
        },
        reservedSize: 40.h,
      ),
    );
  }

  List<HorizontalLine> generateHorizontalLines(double step,double max, double min) {
    List<HorizontalLine> lines = [];

    // حلقه از مقدار صفر شروع می‌شود و پله‌پله به اندازه step بالا می‌رود
    for (double yValue = min; yValue <= (max); yValue += step) {
      lines.add(
        HorizontalLine(
          y: yValue,
          strokeWidth: 1,
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      );
    }
    return lines;
  }

  Future<TimeOfDay?> showCustomTimePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
      ),
    );
  }
}

class LastActivitySlot {
  final String wellName;
  final String date;
  final String time;
  final String name;
  final String status;
  final String type;

  LastActivitySlot(this.wellName, this.date, this.time,this.name,this.status,this.type);
}

class VolumeSlot {
  final String? name;
  final String? status;
  final int? amount;
  final int? capacity;

  VolumeSlot({this.name, this.status, this.amount, this.capacity});
}