
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view/building/building_setup/building_setup.dart';
import '../../view/building/building_view/building_view.dart';
import '../../view/building_sale/sale_building_list/building_view/sale_building_view.dart';
import '../../view/building_sale/sale_view/sale_view.dart';
import '../../view/customer/customer_view.dart';
import '../../view/dashbord/dashbord_page.dart';
import '../../view/sales_report_view_list/sale_report_view.dart';

class DashbordScreenController extends GetxController {


  var dataIndex=0.obs;
  List<Widget> myScreen=[
    const DashboardPage(),
    BuildingSetup(),
    const BuildingView(),
    const SaleBuildingListView(),
    BuildingSalesScreen(),
    const CustomerListView(),
    SalesListReportScreen(),
  ];


}
