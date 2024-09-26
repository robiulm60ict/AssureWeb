
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
      body: Row(
        children: [
          if (Responsive.isDesktop(context)) const Sidebar(),
          if (Responsive.isTablet(context)) const TabSidebar(),
          Expanded(
            child: Column(
              children: [
               Header(drawerKey: _drawerKey),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1360),
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding *
                                (Responsive.isMobile(context) ? 1 : 1.5),
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
    );
  }
}
