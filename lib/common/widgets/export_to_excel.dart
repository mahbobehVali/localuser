import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'global_snackbar.dart';

Future<void> exportToExcel(BuildContext context, List<dynamic> alertsList) async {
  // ۱. ایجاد اکسل و اضافه کردن سطرها (کد قبلی شما...)
  var excel = Excel.createExcel();
  String sheetName = "هشدارها";
  Sheet sheetObject = excel[sheetName];
  excel.setDefaultSheet(sheetName);

  List<CellValue> header = [
    TextCellValue('نام چاه'),
    TextCellValue('نوع هشدار'),
    TextCellValue('تاریخ'),
    TextCellValue('ساعت'),
    TextCellValue('وضعیت'),
  ];
  sheetObject.appendRow(header);

  for (var item in alertsList) {
    String statusText = item.status == 0 ? "جدید" :
    item.status == 1 ? "در حال بررسی" :
    "پاسخ داده شده";
    List<CellValue> row = [
      TextCellValue(item.wellName ?? ''),
      TextCellValue(item.message ?? ''),
      TextCellValue(item.date ?? ''),
      TextCellValue(item.clock ?? ''),
      TextCellValue(statusText),
    ];
    sheetObject.appendRow(row);
  }

  // گرفتن بایت‌های فایل به صورت لیست عددی (Uint8List)
  var fileBytes = excel.save();
  if (fileBytes == null) return;

  try {
    // ۲. باز کردن منوی سیستم عامل و پاس دادن مستقیم بایت‌ها
    // تبدیل List<int> به Uint8List برای سازگاری کامل با متد
    final uint8bytes = Uint8List.fromList(fileBytes);

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'محل ذخیره فایل اکسل را انتخاب کنید:',
      fileName: 'alerts.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: uint8bytes, //  راه حل اصلی: بایت‌ها را مستقیم اینجا پاس می‌دهیم
    );

    // در اندروید و iOS، همین که متد بالا با موفقیت اجرا شود و خروجی null نباشد، یعنی فایل ذخیره شده است
    if (outputFile != null) {
      GlobalSnackBar.show(context, message: "فایل اکسل با موفقیت ذخیره شد");
    } else {
      GlobalSnackBar.show(context, message: "ذخیره فایل لغو شد");
    }
  } catch (e) {
    print("خطا در ذخیره فایل: $e");
    GlobalSnackBar.show(context, message: "خطایی در ذخیره فایل رخ داد");
  }
}