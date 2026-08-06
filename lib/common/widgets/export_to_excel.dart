import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'global_snackbar.dart';

Future<void> exportAlertToExcel(BuildContext context, List<dynamic> alertsList) async {
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
//؟؟؟؟
Future<void> exportVolumeToExcel(BuildContext context, List<dynamic> reportList, int selectedReportIndex) async {
  // ۱. ایجاد اکسل و اضافه کردن سطرها (کد قبلی شما...)
  var excel = Excel.createExcel();
  String sheetName = "مصرف کل آب";
  Sheet sheetObject = excel[sheetName];
  excel.setDefaultSheet(sheetName);

  List<CellValue> header = [
    TextCellValue('تاریخ'),
    TextCellValue('میزان حجم مصرف کل'),
   if(selectedReportIndex==1) TextCellValue('حجم مصرف بیش از حد مجاز'),
    TextCellValue('وضعیت'),
  ];
  sheetObject.appendRow(header);

  for (var item in reportList) {
    String statusText = item.status == 0 ? "جدید" :
    item.status == 1 ? "در حال بررسی" :
    "پاسخ داده شده";
    List<CellValue> row = [
      TextCellValue(item.date ?? ''),
      TextCellValue(item.clock ?? ''),
      if(selectedReportIndex==1) TextCellValue(item.clock ?? ''),
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
      fileName: 'report.xlsx',
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

Future<void> exportPumpToExcel(BuildContext context, List<dynamic> pumpList,int oneWell) async {
  // ۱. ایجاد اکسل و اضافه کردن سطرها (کد قبلی شما...)
  var excel = Excel.createExcel();
  String sheetName = "ساعات کار پمپ";
  Sheet sheetObject = excel[sheetName];
  excel.setDefaultSheet(sheetName);

  List<CellValue> header = [
    TextCellValue(oneWell==1?'تاریخ':"چاه"),
    TextCellValue('مجموع ساعات کارکرد پمپ'),
  ];
  sheetObject.appendRow(header);

  for (var item in pumpList) {
    List<CellValue> row = [
      TextCellValue(item.name ?? ''),
      TextCellValue(item.status ?? ''),
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
      fileName: 'report.xlsx',
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

Future<void> exportAlertReportToExcel(BuildContext context, List<dynamic> alertReportList) async {
  // ۱. ایجاد اکسل و اضافه کردن سطرها (کد قبلی شما...)
  var excel = Excel.createExcel();
  String sheetName = "هشدارهای ارسال شده";
  Sheet sheetObject = excel[sheetName];
  excel.setDefaultSheet(sheetName);

  List<CellValue> header = [
    TextCellValue('نوع هشدار'),
    TextCellValue('تعداد هشدارها'),
  ];
  sheetObject.appendRow(header);

  for (var item in alertReportList) {
    List<CellValue> row = [
      TextCellValue(item.name ?? ''),
      TextCellValue(item.status ?? ''),
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
      fileName: 'report.xlsx',
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

Future<void> exportActivityToExcel(BuildContext context, List<dynamic> activityList) async {
  // ۱. ایجاد اکسل و اضافه کردن سطرها (کد قبلی شما...)
  var excel = Excel.createExcel();
  String sheetName = "اطلاعات دستوردهی به دستگاه";
  Sheet sheetObject = excel[sheetName];
  excel.setDefaultSheet(sheetName);

  List<CellValue> header = [
    TextCellValue('نام چاه'),
    TextCellValue('وضعیت'),
    TextCellValue('توسط'),
    TextCellValue('تاریخ'),
    TextCellValue('ساعت'),
  ];
  sheetObject.appendRow(header);

  for (var item in activityList) {
    List<CellValue> row = [
      TextCellValue(item.wellName ?? ''),
      TextCellValue(item.status ?? ''),
      TextCellValue(item.name ?? ''),
      TextCellValue(item.date ?? ''),
      TextCellValue(item.time ?? ''),
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
      fileName: 'report.xlsx',
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