import 'package:assure_apps/controllers/dashbord_screen_controller/dashbord_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/auth/auth_Controller.dart';
import '../controllers/building_controller/building_controller.dart';
import '../controllers/building_sale_controller/building_sale_controller.dart';
import '../controllers/building_sale_payment_report_controller/building_sale_payment_report_controller.dart';
import '../controllers/customer_controller/customer_controller.dart';
import '../controllers/image/image_controller.dart';
import 'app_colors.dart';
import 'database/login.dart';

class AppConstants {
  static const String appName = "AssureD&D";
}

AuthController authController = Get.put(AuthController());
BuildingController buildingController = Get.put(BuildingController());
GetImageController imageController = Get.put(GetImageController());
BuildingSaleController buildingSaleController = Get.put(BuildingSaleController());
CustomerController customerController = Get.put(CustomerController());
BuildingSalePaymentReportController reportController = Get.put(BuildingSalePaymentReportController());
DashbordScreenController dashbordScreenController = Get.put(DashbordScreenController());
Future<void>? launched;

Future<void> exitAlertDialog(BuildContext context, {required String from}) async {
  if (Navigator.of(context).canPop()) {
    return; // Prevent triggering multiple dialogs
  }

  return showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('Confirmation'),
        content: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Are you sure want to ${from == 'exit' ? 'exit' : from == 'delete' ? 'delete' : 'logout'} ${from == 'delete' ? '' : 'from '}'),
              TextSpan(
                text: from == 'exit' ? '${AppConstants.appName}?' : "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.seed,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              from == 'exit' ? 'No' : 'Cancel',
              style: const TextStyle(color: AppColors.seed),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (from == 'exit') {
                SystemNavigator.pop();
              } else if (from == 'delete') {
                // Your API call for deletion goes here
                await LocalDB.delLoginInfo();
              } else {
                await LocalDB.delLoginInfo(); // Logout operation
              }
              Navigator.of(context).pop(true); // Ensure to pop the dialog after action
            },
            child: Text(
              from == 'exit' ? 'Exit' : from == 'delete' ? 'Delete' : 'Logout',
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      );
    },
  );
}


Column formInfo(String title) {
  return Column(
    children: [
      const SizedBox(height: 10,),
      Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              height: 0.5,
              color: AppColors.black,
            ),
          ),
          Text(title, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900),),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 5),
              height: 0.5,
              color: AppColors.black,
            ),
          )
        ],
      ),
      const SizedBox(height: 10,),
    ],
  );
}