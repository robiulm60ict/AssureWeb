import 'package:assure_apps/view/building/building_setup/building_setup.dart';
import 'package:assure_apps/view/building/building_view/building_view.dart';
import 'package:assure_apps/view/building_sale/sale_building_list/building_view/sale_building_view.dart';
import 'package:assure_apps/view/dashbord/dashbord_page.dart';
import 'package:assure_apps/view/entry_point.dart';
import 'package:assure_apps/view/sign_in_page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../configs/app_constants.dart';
import '../../configs/database/login.dart';
import '../../configs/defaults.dart';
import '../../configs/ghaps.dart';
import '../../configs/routes.dart';
import '../../responsive.dart';
import '../../view/building_sale/sale_view/sale_view.dart';
import '../../view/customer/customer_view.dart';
import '../../view/sales_report_view_list/sale_report_view.dart';
import '../app_alert_dialog.dart';
import 'menu_tile.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: Responsive.isMobile(context) ? double.infinity : null,
      // width: MediaQuery.of(context).size.width < 1300 ? 260 : null,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        color: Colors.black,
                        size: 24.0,
                      ),
                    ),
                  ),
                const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDefaults.padding,
                      vertical: AppDefaults.padding * 1.5,
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedBuilding05,
                      color: Colors.black,
                      size: 40.0,
                    )
                    //  child: Image.asset(AppImage.logo,height: MediaQuery.of(context).size.height*0.20,),
                    ),
              ],
            ),
            const Divider(),
            gapH16,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding,
                ),
                child: ListView(
                  children: [
                    MenuTile(
                      isActive: true,
                      title: "Home",
                      activeIconSrc: "assets/icons/home_filled.svg",
                      inactiveIconSrc: "assets/icons/home_light.svg",
                      onPressed: () {
                        // AppRoutes.pushReplacement(context, page: const EntryPoint());
                      },
                    ),
                    ExpansionTile(
                      leading: const HugeIcon(
                        icon: HugeIcons.strokeRoundedPropertyNew,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      title: Text(
                        "Building",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Building Create",
                          onPressed: () {
                            AppRoutes.push(context, page: BuildingSetup());

                            // context.go('/buildingSetup');
                          },
                        ),
                        Obx(
                          () => MenuTile(
                            isSubmenu: true,
                            title: "Building List",
                            count: buildingController.projects.length,
                            onPressed: () {
                              AppRoutes.push(context,
                                  page: const BuildingView());

                              // context.go('/buildingView');
                            },
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const HugeIcon(
                        icon: HugeIcons.strokeRoundedSaleTag02,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      title: Text(
                        "Building Sale",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        MenuTile(
                          isSubmenu: true,
                          title: "Available Building",
                          onPressed: () {
                            AppRoutes.push(context,
                                page: const SaleBuildingListView());
                          },
                        ),
                        Obx(
                          () => MenuTile(
                            isSubmenu: true,
                            title: "Sale List",
                            count: buildingSaleController.buildingSales.length,
                            onPressed: () {
                              AppRoutes.push(context,
                                  page: BuildingSalesScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const HugeIcon(
                        icon: HugeIcons.strokeRoundedAccountSetting01,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      title: Text(
                        "Customer Manage",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        Obx(
                          () => MenuTile(
                            isSubmenu: true,
                            title: "Customer List",
                            count: customerController.customers.length,
                            onPressed: () {
                              AppRoutes.push(context,
                                  page: const CustomerListView());
                            },
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      leading: const HugeIcon(
                        icon: HugeIcons.strokeRoundedSaleTag01,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      title: Text(
                        "Sales Manage",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      children: [
                        Obx(
                          () => MenuTile(
                            isSubmenu: true,
                            title: "Sales report List",
                            count: reportController.buildingSalesReport.length,
                            onPressed: () {
                              AppRoutes.push(context,
                                  page: SalesReportScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          appAlertDialog(context, "Are you sure to logout?",
                              title: "Logout",
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Dismiss")),
                                TextButton(
                                    onPressed: () {
                                      LocalDB.delLoginInfo();
                                      AppRoutes.pushAndRemoveUntil(context,
                                          page: SignInPage());
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ]);
                        },
                        child: const Row(
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedLogout01,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            gapW16,
                            Text(
                              "LogOut",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InstallmentTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installment Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // Allows horizontal scrolling if needed
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Text('Installment'),
            ),
            DataColumn(
              label: Text('Taka (Schedule)'),
            ),
            DataColumn(
              label: Text('Date'),
            ),
            DataColumn(
              label: Text('Status'),
            ),
          ],
          rows: const <DataRow>[
            DataRow(
              cells: <DataCell>[
                DataCell(Text('1st Installment')),
                DataCell(Text('5000')),
                DataCell(Text('2024-09-01')),
                DataCell(Text('Paid')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('2nd Installment')),
                DataCell(Text('6000')),
                DataCell(Text('2024-10-01')),
                DataCell(Text('Unpaid')),
              ],
            ),
            DataRow(
              cells: <DataCell>[
                DataCell(Text('3rd Installment')),
                DataCell(Text('7000')),
                DataCell(Text('2024-11-01')),
                DataCell(Text('Unpaid')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
