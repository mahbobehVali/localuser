import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void customError(){
  ErrorWidget.builder=(FlutterErrorDetails details){
    return Scaffold(
      appBar: AppBar(
        title: Text("Error Message"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Error"),
            Text(kDebugMode?"oups! something went wrong": details.exception.toString()),
          ],
        ),
      ),
    );
  };}