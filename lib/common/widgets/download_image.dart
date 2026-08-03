
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

import '../../config/color_palette.dart';
import 'directory_path.dart';

class PayvastSupportFile extends StatefulWidget {
   const PayvastSupportFile({super.key,required this.url});
  final String url;

  @override
  State<PayvastSupportFile> createState() => _PayvastSupportFileState();
}

class _PayvastSupportFileState extends State<PayvastSupportFile> {
  bool downloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  Future<void> startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      downloading = true;
      progress = 0;
    });

    try {
      await Dio().download(widget.url, filePath,
          onReceiveProgress: (count, total) {
            setState(() {
              progress = (count / total);
            });
          }, cancelToken: cancelToken);
      setState(() {
        downloading = false;
        fileExists = true;
      });
    } catch (e) {
      setState(() {
        downloading = false;
      });
    }
  }

  void cancelDownload() {
    cancelToken.cancel();
    setState(() {
      downloading = false;
    });
  }

  Future<void> checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  void openFile() {
    OpenFile.open(filePath);
    // print("fff $filePath");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = path.basename(widget.url);
    });
    checkFileExit();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: BoxBorder.all(color: ColorPalette.inverseGrey)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("فایل پیوست"),
          IconButton(
              onPressed: () {
                fileExists && downloading == false
                    ? openFile()
                    :(downloading?cancelDownload():startDownload());
              },
              icon: fileExists && downloading == false
                  ? Icon(Icons.file_copy_outlined, color: Colors.green) // اگر شرط اول درست باشد، این آیکون برگردانده می‌شود
                  : (downloading // اگر شرط اول غلط باشد، این شرط جدید ارزیابی می‌شود
                  ? Stack(
                alignment: Alignment.center,
                children: [

                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blue),
                  ),
                  Icon(Icons.close)
                ],
              ) // در اینجا باید آیکون متناسب با 'downloading == true' بیاید
                  : Icon(Icons.save_alt) // و اینجا آیکون متناسب با 'fileExists == false && downloading == false' (که در شرط اول پوشش داده نشده)
              ) ),
        ],
      ),
    );
  }
}
