import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth/auth_Controller.dart';
import '../controllers/building_controller/building_controller.dart';
import '../controllers/building_sale_controller/building_sale_controller.dart';
import '../controllers/building_sale_payment_report_controller/building_sale_payment_report_controller.dart';
import '../controllers/customer_controller/customer_controller.dart';
import '../controllers/image/image_controller.dart';
import 'app_colors.dart';

class AppConstants {
  static const String appName = "ASSURE GROUP";
}

AuthController authController = Get.put(AuthController());
BuildingController buildingController = Get.put(BuildingController());
GetImageController imageController = Get.put(GetImageController());
BuildingSaleController buildingSaleController = Get.put(BuildingSaleController());
CustomerController customerController = Get.put(CustomerController());
BuildingSalePaymentReportController reportController = Get.put(BuildingSalePaymentReportController());
Future<void>? launched;
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