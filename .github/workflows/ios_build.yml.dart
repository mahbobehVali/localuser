name: Build Flutter iOS

on:
push:
branches:
- main # یا هر شاخه‌ای که روی آن کار می‌کنید
workflow_dispatch: # امکان اجرای دستی از داخل گیتهاب

jobs:
build-ios:
runs-on: macos-latest # اجرای فرایند روی سرور مک‌او‌اس گیتهاب

steps:
# ۱. دریافت کد پروژه از گیتهاب
- name: Checkout Repository
uses: actions/checkout@v4

# ۲. نصب و تنظیم زبان جاوا (برای وابستگی‌های احتمالی)
- name: Set up Java
uses: actions/setup-java@v4
with:
distribution: 'zulu'
java-version: '17'

# ۳. نصب و تنظیم فلاتر
- name: Set up Flutter
uses: subosito/flutter-action@v2
with:
flutter-version: '3.x' # یا نسخه مدنظرتان مثل 3.24.0
channel: 'stable'
cache: true

# ۴. دریافت پکیج‌های فلاتر
- name: Install Dependencies
run: flutter pub get

# ۵. ساخت خروجی iOS (بدون نیاز به امضای دیجیتال برای خروجی اولیه)
- name: Build iOS Application
run: flutter build ios --release --no-codesign

# ۶. آرشیو کردن و اماده‌سازی پوشه خروجی جهت دانلود
- name: Compress iOS App
run: |
mkdir -p build/ios/iphoneos/Payload
mv build/ios/iphoneos/Runner.app build/ios/iphoneos/Payload/
cd build/ios/iphoneos
zip -r Runner.ipa Payload

# ۷. آپلود فایل IPA ساخته شده در گیتهاب
- name: Upload IPA Artifact
uses: actions/upload-artifact@v4
with:
name: ios-build
path: build/ios/iphoneos/Runner.ipa