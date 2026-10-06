import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahaliii/config/color_palette.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../features/support_feature/presentation/bloc/support_bloc.dart';
import 'global_elevated_button.dart';

class BottomSheets {

  Future<void> _showSettingsPrompt(BuildContext context, String permissionName) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'دسترسی $permissionName رد شده است',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 10),
              const Text(
                'لطفاً برای استفاده از این قابلیت، به تنظیمات بروید و مجوزهای لازم را فعال کنید.',
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(bc); // بستن باتم شیت
                    },
                    child: const Text('انصراف',style: TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 10),
                  GlobalElevatedButton(
                    backColor: ColorPalette.darkBlue,

                    onTap: () {
                      Navigator.pop(bc); // بستن باتم شیت
                      openAppSettings(); // رفتن به تنظیمات
                    },
                    widget: const Text('رفتن به تنظیمات',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
// ----------------------------------------------------
// متدهای کمکی برای مدیریت مجوزها
// ----------------------------------------------------

// بررسی و درخواست مجوز برای یک منبع خاص
// متد اصلاح شده برای بررسی و درخواست مجوز
  Future<bool> _checkAndRequestPermission(BuildContext context, ImageSource source) async {
    PermissionStatus status;
    String permissionName;

    if (source == ImageSource.camera) {
      permissionName = 'دوربین';
      // ۱. ابتدا بررسی وضعیت فعلی دسترسی
      status = await Permission.camera.status;

      if (!status.isGranted && !status.isLimited) {
        // ۲. اگر دسترسی ندارد، درخواست بده
        status = await Permission.camera.request();
      }
    } else {
      permissionName = 'گالری';

      if (Platform.isAndroid) {
        // برای اندروید: بررسی براساس نیاز سیستم‌عامل
        // در اندروید ۱۳+ ابتدا photos چک می‌شود، اگر پشتیبانی نشد به سراغ storage می‌رود
        Permission targetPermission = Permission.photos;

        status = await targetPermission.status;

        // اگر Photos محدود یا ناامیدکننده بود، Storage را تست کن (برای اندروید ۱۲ به پایین)
        if (status.isDenied) {
          PermissionStatus storageStatus = await Permission.storage.status;
          if (storageStatus.isGranted) {
            return true;
          }

          // درخواست برای photos؛ اگر منسوخ بود storage را درخواست بده
          status = await Permission.photos.request();
          if (status.isDenied) {
            status = await Permission.storage.request();
          }
        }
      } else {
        // برای iOS
        status = await Permission.photos.status;
        if (!status.isGranted && !status.isLimited) {
          status = await Permission.photos.request();
        }
      }
    }

    // ۱. اگر دسترسی داده شد (کامل یا محدود)
    if (status.isGranted || status.isLimited) {
      return true;
    }

    // ۲. اگر کاربر دسترسی را برای همیشه رد کرده است
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        await _showSettingsPrompt(context, permissionName);
      }
      return false;
    }

    // ۳. اگر رد شد (Denied)
    return false;
  }


  Future<void> imageSupport(BuildContext context, SupportBloc supportBloc) async {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: supportBloc,
          child: SizedBox(
            height: 70.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // دکمه دوربین
                GlobalElevatedButton(
                  widget: const Text("دوربین", style: TextStyle(color: Colors.black)),
                  onTap: () async {
                    // اول BottomSheet را ببندید تا Context مشکلی پیدا نکند
                    Navigator.of(ctx).pop();

                    final cameraGranted = await _checkAndRequestPermission(context, ImageSource.camera);
                    if (cameraGranted) {
                      supportBloc.add(AddSupportImageClicked());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("برای گرفتن عکس، به دسترسی دوربین نیاز است.")),
                      );
                    }
                  },
                ),

                // دکمه گالری
                GlobalElevatedButton(
                  widget: const Text("گالری", style: TextStyle(color: Colors.black)),
                  onTap: () async {
                    Navigator.of(ctx).pop();

                    final galleryGranted = await _checkAndRequestPermission(context, ImageSource.gallery);
                    if (galleryGranted) {
                      supportBloc.add(AddSupportFileClicked());
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("برای انتخاب فایل، به دسترسی گالری نیاز است.")),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}











