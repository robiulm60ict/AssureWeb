import 'package:assure_apps/view/building_sale/sale_building_list/building_view/sale_building_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../configs/app_constants.dart';
import '../../configs/defaults.dart';
import '../../configs/ghaps.dart';
import '../../responsive.dart';
import '../../view/building/building_view/building_view.dart';
import '../../view/building_sale/sale_view/sale_view.dart';
import '../../view/customer/customer_view.dart';
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
                  child: HugeIcon(icon: HugeIcons.strokeRoundedBuilding05, color: Colors.black ,size: 40.0,)
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
                      onPressed: () {},
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
                            context.go('/buildingSetup');

                          },
                        ),
                        Obx(
                          ()=> MenuTile(
                            isSubmenu: true,
                            title: "Building List",
                            count: buildingController.projects.length,
                            onPressed: () {
                              context.go('/buildingView');

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
                          title: "Building Sale",
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SaleBuildingListView()));

                            // context.go('/saleBuildingListView');
                            // context.go('/buildingSaleSetup');

                          },
                        ),
                        Obx(
                          ()=> MenuTile(
                            isSubmenu: true,
                            title: "Sale List",
                            count: buildingSaleController.buildingSales.length,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>BuildingSalesScreen()));
                              // context.go('/buildingView');

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
                        ()=> MenuTile(
                            isSubmenu: true,
                            title: "Customer List",
                            count: customerController.customers.length,
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerListView()));

                            },
                          ),
                        ),

                      ],
                    ),

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
        title: Text('Installment Table'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allows horizontal scrolling if needed
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