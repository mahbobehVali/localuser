import 'dart:async';

import 'package:flutter/material.dart';

class DeBouncer{
  final int milliseconds;
  Timer? timer;

  DeBouncer({required this.milliseconds});
void run(VoidCallback action){
  if(timer!=null){
    timer!.cancel();
  }

  timer=Timer(Duration(milliseconds: milliseconds),
      action);
}

void reset(){
  timer=null;
}




}