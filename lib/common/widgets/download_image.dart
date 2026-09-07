
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as Path;

import '../../config/color_palette.dart';
import 'directory_path.dart';

class PayvastSupportFile extends StatefulWidget {
  PayvastSupportFile({super.key,required this.url});
  String url;

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

  startDownload() async {
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
      print(e);
      setState(() {
        downloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      downloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  openfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileName = Path.basename(widget.url);
    });
    checkFileExit();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fileExists && downloading == false
            ? openfile()
            :(downloading?cancelDownload():startDownload());
      },
      child: Container(
        decoration: BoxDecoration(
            border: BoxBorder.all(color: ColorPalette.grey)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("فایل پیوست",style: TextStyle(color: ColorPalette.black)),
              fileExists && downloading == false
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
                  Icon(Icons.close,color: ColorPalette.white)
                ],
              ) // در اینجا باید آیکون متناسب با 'downloading == true' بیاید
                  : Icon(Icons.save_alt,color: ColorPalette.white,) // و اینجا آیکون متناسب با 'fileExists == false && downloading == false' (که در شرط اول پوشش داده نشده)
              )
            ],
          ),
        ),
      ),
    );
  }
}
