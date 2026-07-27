import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class ImageConverter {
  /// get imagePath and convert to base64-image
  static Future<String> getBase64Image(dynamic path) async {

    if (path.startsWith("http") || path == "") {

      return "null";
    } else {
      // List<int> imageBytes = await path.readAsBytesSync();
      // String  base
      // 64Image = base64Encode(imageBytes);
      // return base64Image;
      return "data:image/${p.extension(path).replaceFirst(".", "")};base64,${base64Encode(await File(path).readAsBytes())}";
    }
  }

  static Future<String> getBase64ImageContact(dynamic path) async {

    if (path == "") {

      return "";
    } else {
      // List<int> imageBytes = await path.readAsBytesSync();
      // String  base
      // 64Image = base64Encode(imageBytes);
      // return base64Image;
      return "data:image/${p.extension(path).replaceFirst(".", "")};base64,${base64Encode(await File(path).readAsBytes())}";
    }
  }




  // static Future<String> getBase64Image(String imagePath) async {
  //   // اگر مسیر فایل خالی است یا یک URL است، نیازی به تبدیل نیست.
  //   // می‌توانید بسته به نیاز خود، اینجا "null" برگردانید یا یک رشته خالی،
  //   // یا حتی یک پیام خطا.
  //   if (imagePath.isEmpty || imagePath.startsWith("http")) {
  //     return "null"; // یا هر مقدار دیگری که منطقی است
  //   }
  //
  //   try {
  //     final File imageFile = File(imagePath);
  //     // بررسی کنید آیا فایل وجود دارد
  //     if (!await imageFile.exists()) {
  //       print("Error: File not found at path: $imagePath");
  //       return "null"; // یا یک رشته خطای مشخص
  //     }
  //
  //     // بایت‌های فایل را بخوانید
  //     List<int> imageBytes = await imageFile.readAsBytes();
  //
  //     // تبدیل بایت‌ها به رشته Base64
  //     String base64Image = base64Encode(imageBytes);
  //
  //     // دریافت پسوند فایل برای تعیین نوع تصویر (jpeg, png, etc.)
  //     String fileExtension = p.extension(imagePath).replaceFirst(".", "").toLowerCase();
  //
  //     // ساخت Data URL
  //     return "data:image/$fileExtension;base64,$base64Image";
  //   } catch (e) {
  //     print("Error converting image to Base64: $e");
  //     return "null"; // در صورت بروز خطا، مقدار null یا خطایی را برگردانید
  //   }
  // }





  /// get imagePath and convert to multiPart
  static Future<Object> getMultiPart(String path,String fileName) async {
    if(path.isEmpty){
      return "";
    }
    // else if (kIsWeb) {
    //   // برای وب: از بایت‌های فایل استفاده کنید
    //   Uint8List fileBytes = platformFile.bytes!;
    //   String fileName = platformFile.name;
    //
    //   return MultipartFile.fromBytes(
    //     fileBytes,
    //     filename: fileName,
    //     // contentType: MediaType('application', 'octet-stream'), // در صورت نیاز
    //   );
    // }
    else{
      return await MultipartFile.fromFile(path,filename: fileName);
    }

  }

// /// convert path to base64 image
// static shouldDeleteImage(String path){
//   if(path.startsWith("http")){
//     return false;
//   }else{
//     return true;
//   }
// }
}
