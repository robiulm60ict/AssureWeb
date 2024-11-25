import 'package:assure_apps/configs/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/defaults.dart';
import '../responsive.dart';
import '../widgets/header.dart';
import '../widgets/sidemenu/sidebar.dart';


class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final GlobalKey<ScaffoldState> scaffoldKeySidebar = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKeyEntry = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKeyEntry,
      drawer: Responsive.isMobile(context) ? const Sidebar() : null,
      body: PopScope(
        canPop: false,
        onPopInvoked: (v) async {
          await exitAlertDialog(context, from: 'exit');
          return;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            customerController.fetchCustomer();
            buildingController.fetchProjects();
            buildingSaleController.fetchAllBuildingSales();
          },
          child: Row(
            children: [
              if (Responsive.isDesktop(context)) const Sidebar(),
              if (Responsive.isTablet(context)) const Sidebar(),
              Obx(
                    () => Expanded(
                  child: Column(
                    children: [
                      Header(drawerKey: scaffoldKeySidebar),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDefaults.padding *
                                    (Responsive.isMobile(context) ? 0.5 : 1.5),
                              ),
                              child: dashbordScreenController.myScreen[
                              dashbordScreenController.dataIndex.value],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


