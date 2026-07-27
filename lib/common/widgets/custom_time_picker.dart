import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../../../../../../common/widgets/convert_to_persian_number.dart';

class CustomTimePicker extends StatefulWidget {

  final Function(String hour, String minute,String endA,String endB, bool conflict) onTimeSelected;
  final DateTime? initialTime;

  // List<MonthlyOtherEntity> monthlyOtherEntity;
  final int index;

  const CustomTimePicker({
    super.key,
    required this.onTimeSelected,
    this.initialTime,
    // required this.monthlyOtherEntity,
     this.index=0
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  String endHour = '00';
  String endMinute = '45';
  bool _hasConflict = true;

  @override

  void initState() {
    super.initState();

    final now =  widget.initialTime ?? DateTime.now();
    widget.initialTime==null?_updateTime(now.hour, now.minute):
    _updateTime(widget.initialTime!.hour, widget.initialTime!.minute);

    // Call the callback function initially
    _notifyParent();

    _hourController.addListener(_validateHour);
    _minuteController.addListener(_validateMinute);
  }

  @override
  void dispose() {
    // ۱. حذف لیسنرها برای جلوگیری از اجرای کدهای اضافه هنگام بسته شدن
    _hourController.removeListener(_validateHour);
    _minuteController.removeListener(_validateMinute);

    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();

  }

  bool _checkConflict(int userStartH, int userStartM, int userEndH, int userEndM) {
    List<bool> conflict=[];

   return conflict.every((element) => element);
  }

  void _calculateEndTime(int startHour, int startMinute) {
    const int durationMinutes = 45;

    // مجموع دقایق را محاسبه می‌کند
    int totalMinutes = startMinute + durationMinutes;

    // دقیقه جدید را محاسبه می‌کند (بین ۰ تا ۵۹)
    int newMinute = totalMinutes % 60;

    // تعداد ساعاتی که از ۶۰ دقیقه پر شده و باید اضافه شود
    //10 ~/ 2 =5
    //-10 ~/ 3= -3
    int hourCarry = totalMinutes ~/ 60;

    // ساعت جدید را محاسبه می‌کند (بین ۰ تا ۲۳)
    int newHour = (startHour + hourCarry) % 24;

    // متغیرهای داخلی را با زمان محاسبه شده (به صورت استرینگ فرمت‌شده) به‌روز می‌کند
    endHour = newHour.toString().padLeft(2, '0');
    endMinute = newMinute.toString().padLeft(2, '0');

    // print("endhour${endHour}");
    // print("endminute${endMinute}");
  }

  void _updateTime(int hour, int minute) {
    _hourController.text = hour.toString().padLeft(2, '0').toPersianDigit();
    _minuteController.text = minute.toString().padLeft(2, '0').toPersianDigit();
    // print("hour${_hourController.text}");
    // print("minut${_minuteController.text}");
    _notifyParent();
  }

  int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  void _notifyParent() {
    // ۳. چک کردن mounted قبل از اجرای هرگونه منطق مربوط به UI
    if (!mounted) return;

    int? startHour = int.tryParse(_hourController.text.toEnglishDigit());
    int? startMinute = int.tryParse(_minuteController.text.toEnglishDigit());

    if (startHour != null && startMinute != null) {
      // ** فراخوانی تابع جدید برای محاسبه زمان پایان **
      _calculateEndTime(startHour, startMinute);

      int endHou = int.tryParse(endHour) ?? 0;
      int endMinut = int.tryParse(endMinute) ?? 0;

      setState(() {
        _hasConflict = _checkConflict(
            startHour,
            startMinute,
            endHou,
            endMinut
        );
      });
    }

    widget.onTimeSelected(
        _hourController.text.toEnglishDigit(),
        _minuteController.text.toEnglishDigit(),
        endHour,
        endMinute,
        _hasConflict
    );
  }

  void _validateHour() {
    if (!mounted) return; // اضافه کردن این خط
    String persianHour = _hourController.text;
    String englishHour = persianHour.toEnglishDigit();
    int? hour = int.tryParse(englishHour);
    String englishMinute = _minuteController.text.toEnglishDigit();
    int? minute = int.tryParse(englishMinute);

    if (hour != null && minute != null) {
      if (hour < 0 || hour > 23) {
        // ورودی نامعتبر: ساعت و دقیقه هر دو 00 می‌شوند (منطق قبلی)
        _hourController.text = '00'.toPersianDigit();
        _minuteController.text = '00'.toPersianDigit();
      } else if (hour == 0) {
        // اگر ساعت 00 شد، دقیقه را هم 00 کن (منطق قبلی)
        if (minute != 0) {
          _minuteController.text = '00'.toPersianDigit();
        }
      } else if (hour == 23) {
        // منطق جدید: اگر ساعت 23 شد و دقیقه بیشتر از 15 بود، دقیقه را 15 کن
        if (minute > 15) {
          _minuteController.text = '15'.toPersianDigit();
        }
      }
    }

    // تنظیم مکان‌نما
    _hourController.selection = TextSelection.fromPosition(
      TextPosition(offset: _hourController.text.length),
    );
    _notifyParent();
  }
  void _validateMinute() {
    if (!mounted) return; // اضافه کردن این خط
    String persianMinute = _minuteController.text;
    String englishMinute = persianMinute.toEnglishDigit();
    int? minute = int.tryParse(englishMinute);

    String englishHour = _hourController.text.toEnglishDigit();
    int? hour = int.tryParse(englishHour);

    if (minute != null) {
      if (minute < 0 || minute > 59) {
        // ورودی نامعتبر: ریست دقیقه به 00
        _minuteController.text = '00'.toPersianDigit();
      } else if (hour == 23 && minute > 15) {
        // منطق جدید: اگر ساعت 23 بود، دقیقه نمی‌تواند بیشتر از 15 باشد
        _minuteController.text = '15'.toPersianDigit();
      }
    }

    // تنظیم مکان‌نما
    _minuteController.selection = TextSelection.fromPosition(
      TextPosition(offset: _minuteController.text.length),
    );
    _notifyParent();
  }

  Widget _buildMinuteField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: [
        SizedBox(
          width: 50,
          child: TextField(
            inputFormatters: [
              PersianNumberWithLengthInputFormatter(),
            ],

            controller: _minuteController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        // const SizedBox(width: 8),
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     _buildButton(Icons.add, _incrementMinute),
        //     _buildButton(Icons.remove, _decrementMinute),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildHourField() {
    // print("hourfield${_hourController.text}");

    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.ltr,
      children: [
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     _buildButton(Icons.add, _incrementHour),
        //     _buildButton(Icons.remove, _decrementHour),
        //   ],
        // ),
        // const SizedBox(width: 8),

        SizedBox(
          width: 50,
          child: TextField(
            inputFormatters: [
              PersianNumberWithLengthInputFormatter(),

            ],
            controller: _hourController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      width: 160.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all()

      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMinuteField(),
            const Text(
              ':',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildHourField(),
          ],
        ),
      ),
    );
  }
}