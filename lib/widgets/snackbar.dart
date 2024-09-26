import 'package:flutter/material.dart';
import 'package:get/get.dart';

//!For success snackbar
successSnackBar(String exp){
   return Get.snackbar('Success', exp,
     icon: const Icon(Icons.check, color: Colors.white),
     snackPosition: SnackPosition.TOP,
     borderRadius: 8,
     margin: const EdgeInsets.all(15),
     backgroundColor: Colors.green,
     colorText: Colors.white,
     duration: const Duration(milliseconds: 2500),
     isDismissible: true,
     dismissDirection: DismissDirection.horizontal,
     forwardAnimationCurve: Curves.easeOutBack,
   );
}

//!For wrong snack bar
wrongSnackBar(String exp, {String? title}){
  return Get.snackbar(title ?? 'Something wrong', exp,
    icon: const Icon(Icons.error_outline, color: Colors.white),
    snackPosition: SnackPosition.TOP,
    borderRadius: 8,
    margin: const EdgeInsets.all(15),
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(milliseconds: 2500),
    isDismissible: true,
    dismissDirection: DismissDirection.vertical,
    forwardAnimationCurve: Curves.easeOutBack,
  );
}

