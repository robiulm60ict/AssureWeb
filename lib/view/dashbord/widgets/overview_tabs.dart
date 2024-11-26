import 'package:assure_apps/configs/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../widgets/tabs/tab_with_growth.dart';
import 'customers_overview.dart';
import 'revenue_line_chart.dart';

class OverviewTabs extends StatefulWidget {
  const OverviewTabs({
    super.key,
  });

  @override
  State<OverviewTabs> createState() => _OverviewTabsState();
}

class _OverviewTabsState extends State<OverviewTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int _selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.bgLight,
            borderRadius:
                BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
          ),
          child: TabBar(
            controller: _tabController,
            dividerHeight: 0,
            padding: const EdgeInsets.symmetric(
                horizontal: 0, vertical: AppDefaults.padding),
            indicator:  BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(AppDefaults.borderRadius),
              ),
              color: AppColors.bgSecondayLight,
            ),
            tabs: [
              Obx(
                () => TabWithGrowth(
                  title: "Customers",
                  amount:
                      customerController.customersFilter.length.toString() ??
                          "",
                  growthPercentage: "20%",
                ),
              ),
              Obx(
                () => TabWithGrowth(
                  title: "Sale",
                  iconSrc: "assets/icons/activity_light.svg",
                  iconBgColor: AppColors.secondaryLavender,
                  amount: reportController.totalSalesAmount.value
                      .toStringAsFixed(2),
                  growthPercentage: "2.7%",
                  isPositiveGrowth: false,
                ),
              )
            ],
          ),
        ),
        gapH24,
        Obx(
          () => SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Center(
                    child: reportController.isDateFilterLoading.value == true
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const CoustomersOverview()),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding * 1.5,
                    vertical: AppDefaults.padding,
                  ),
                  child: reportController.isDateLoading.value == true
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : SalesReportScreen(),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}
