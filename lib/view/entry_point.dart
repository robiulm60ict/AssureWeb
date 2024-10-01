
import 'package:assure_apps/configs/app_constants.dart';
import 'package:flutter/material.dart';

import '../configs/defaults.dart';
import '../responsive.dart';
import '../widgets/header.dart';
import '../widgets/sidemenu/sidebar.dart';
import '../widgets/sidemenu/tab_sidebar.dart';
import 'dashbord/dashbord_page.dart';



final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: Responsive.isMobile(context) ? const Sidebar() : null,
      body: RefreshIndicator(
        onRefresh: ()async{
          customerController.fetchCustomer();
          buildingController.fetchProjects();
          buildingSaleController.fetchAllBuildingSales();
        },
        child: Row(
          children: [
            if (Responsive.isDesktop(context)) const Sidebar(),
            // if (Responsive.isTablet(context)) const TabSidebar(),
            if (Responsive.isTablet(context)) const Sidebar(),
            Expanded(
              child: Column(
                children: [
                 Header(drawerKey: _drawerKey),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1360),
                      child: ListView(
                        physics: const ScrollPhysics( ),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDefaults.padding *
                                  (Responsive.isMobile(context) ? 0.5 : 1.5),
                            ),
                            child: SafeArea(child: DashboardPage()),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
