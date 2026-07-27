// این کد را در یک فایل جداگانه (مثلاً: custom_formatters.dart) یا در بالای فایل فعلی اضافه کنید.

import 'package:flutter/services.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PersianNumberWithLengthInputFormatter extends TextInputFormatter {
  final int maxLength;

  PersianNumberWithLengthInputFormatter({this.maxLength = 2});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 1. تبدیل ارقام فارسی به انگلیسی برای اعتبارسنجی
    String newText = newValue.text.toEnglishDigit();

    // 2. حذف کاراکترهای غیر عددی
    String filteredText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // 3. اعمال محدودیت طول (مثلاً 2 کاراکتر)
    if (filteredText.length > maxLength) {
      filteredText = filteredText.substring(0, maxLength);
    }

    // 4. تبدیل مجدد به ارقام فارسی برای نمایش در TextField
    String displayText = filteredText.toPersianDigit();

    // اگر متن فیلتر شده با متن جدید یکی نیست، تغییرات را اعمال کن
    if (displayText != newValue.text) {
      return TextEditingValue(
        text: displayText,
        selection: TextSelection.collapsed(offset: displayText.length),
      );
    }

    // اگر تغییری نیاز نیست، مقدار اصلی را برگردان
    return newValue;
  }
}


class PersianNumberInputFormatter extends TextInputFormatter {

  PersianNumberInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 1. تبدیل ارقام فارسی به انگلیسی برای اعتبارسنجی
    String newText = newValue.text.toEnglishDigit();

    // 2. حذف کاراکترهای غیر عددی
    String filteredText = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // 4. تبدیل مجدد به ارقام فارسی برای نمایش در TextField
    String displayText = filteredText.toPersianDigit();

    // اگر متن فیلتر شده با متن جدید یکی نیست، تغییرات را اعمال کن
    if (displayText != newValue.text) {
      return TextEditingValue(
        text: displayText,
        selection: TextSelection.collapsed(offset: displayText.length),
      );
    }

    // اگر تغییری نیاز نیست، مقدار اصلی را برگردان
    return newValue;
  }
}
