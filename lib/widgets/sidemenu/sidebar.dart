import 'package:assure_apps/view/sign_in_page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_constants.dart';
import '../../configs/database/login.dart';
import '../../configs/defaults.dart';
import '../../configs/ghaps.dart';
import '../../configs/routes.dart';
import '../../responsive.dart';
import '../app_alert_dialog.dart';
import 'menu_tile.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        // width: Responsive.isMobile(context) ? double.infinity : null,
        // width: MediaQuery.of(context).size.width < 1300 ? 260 : null,
        child: Container(
      color: AppColors.bg,
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
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding,
                  ),
                  child: ListView(
                    children: [
                      MenuTile(
                        isActive: dashbordScreenController.dataIndex.value == 0
                            ? true
                            : false,
                        // isActive: dashbordScreenController.dataIndex.value==0? true:false,
                        title: "Home",
                        activeIconSrc: "assets/icons/home_filled.svg",
                        inactiveIconSrc: "assets/icons/home_light.svg",
                        onPressed: () {
                          dashbordScreenController.dataIndex.value = 0;
                          if (Responsive.isMobile(context)) {
                            Navigator.pop(context);
                          }
                          // AppRoutes.pushReplacement(context, page: const EntryPoint());
                        },
                      ),
                      Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: const HugeIcon(
                            icon: HugeIcons.strokeRoundedPropertyNew,
                            color: Colors.black,
                            size: 24.0,
                          ),
                          title: Text(
                            "Building",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                          children: [
                            MenuTile(
                              isActive:
                                  dashbordScreenController.dataIndex.value == 1
                                      ? true
                                      : false,
                              isSubmenu:
                                  dashbordScreenController.dataIndex.value == 1
                                      ? true
                                      : false,
                              title: "Building Create",
                              onPressed: () {
                                if (Responsive.isMobile(context)) {
                                  Navigator.pop(context);
                                }
                                buildingController.clearData();

                                dashbordScreenController.dataIndex.value = 1;
                                // AppRoutes.push(context, page: EntryPointBuildingSetup());
                                // AppRoutes.push(context, page: BuildingSetup());

                                // context.go('/buildingSetup');
                              },
                            ),
                            Obx(
                              () => MenuTile(
                                isActive:
                                    dashbordScreenController.dataIndex.value ==
                                            2
                                        ? true
                                        : false,
                                isSubmenu:
                                    dashbordScreenController.dataIndex.value ==
                                            2
                                        ? true
                                        : false,
                                title: "Building List",
                                count: buildingController.projects.length,
                                onPressed: () {
                                  if (Responsive.isMobile(context)) {
                                    Navigator.pop(context);
                                  }
                                  dashbordScreenController.dataIndex.value = 2;
                                  // AppRoutes.push(context,
                                  //     page: const BuildingView());

                                  // context.go('/buildingView');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Theme(
                          data: ThemeData()
                              .copyWith(dividerColor: Colors.transparent),
                          child:    ExpansionTile(
                            leading: const HugeIcon(
                              icon: HugeIcons.strokeRoundedSaleTag02,
                              color: Colors.black,
                              size: 24.0,
                            ),
                            title: Text(
                              "Building Sale",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                            ),
                            children: [
                              MenuTile(
                                isActive:
                                dashbordScreenController.dataIndex.value == 3
                                    ? true
                                    : false,
                                isSubmenu:
                                dashbordScreenController.dataIndex.value == 3
                                    ? true
                                    : false,
                                title: "Available Building",
                                onPressed: () {
                                  if (Responsive.isMobile(context)) {
                                    Navigator.pop(context);
                                  }
                                  dashbordScreenController.dataIndex.value = 3;

                                  // AppRoutes.push(context,
                                  //     page: const SaleBuildingListView());
                                },
                              ),
                              Obx(
                                    () => MenuTile(
                                  isActive:
                                  dashbordScreenController.dataIndex.value == 4
                                      ? true
                                      : false,
                                  isSubmenu:
                                  dashbordScreenController.dataIndex.value == 4
                                      ? true
                                      : false,
                                  title: "Sale List",
                                  count:
                                  buildingSaleController.buildingSales.value.length,
                                  onPressed: () {
                                    if (Responsive.isMobile(context)) {
                                      Navigator.pop(context);
                                    }
                                    dashbordScreenController.dataIndex.value = 4;
                                    // AppRoutes.push(context,
                                    //     page: BuildingSalesScreen());
                                  },
                                ),
                              ),
                            ],
                          ),),
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
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        children: [
                          Obx(
                            () => MenuTile(
                              isActive:
                                  dashbordScreenController.dataIndex.value == 5
                                      ? true
                                      : false,
                              isSubmenu:
                                  dashbordScreenController.dataIndex.value == 5
                                      ? true
                                      : false,
                              title: "Customer List",
                              count: customerController.customers.length,
                              onPressed: () {
                                if (Responsive.isMobile(context)) {
                                  Navigator.pop(context);
                                }
                                dashbordScreenController.dataIndex.value = 5;

                                // AppRoutes.push(context,
                                //     page: const CustomerListView());
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
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        children: [
                          Obx(
                            () => MenuTile(
                              isActive:
                                  dashbordScreenController.dataIndex.value == 6
                                      ? true
                                      : false,
                              isSubmenu:
                                  dashbordScreenController.dataIndex.value == 6
                                      ? true
                                      : false,
                              title: "Sales report List",
                              count:
                                  reportController.buildingSalesReport.length,
                              onPressed: () {
                                if (Responsive.isMobile(context)) {
                                  Navigator.pop(context);
                                }
                                dashbordScreenController.dataIndex.value = 6;

                                // AppRoutes.push(context,
                                //     page: SalesReportScreen());
                              },
                            ),
                          ),
                        ],
                      ),
                      if (Responsive.isMobile(context))
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
            ),
          ],
        ),
      ),
    ));
  }
}
