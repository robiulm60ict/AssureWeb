

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> appLoader(BuildContext context,String msg) async{
  final alert= AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset('assets/json/loader.json',height: 100,width: 100),
        Text("$msg\n"),
      ],),
  );
  await showDialog(
    barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}