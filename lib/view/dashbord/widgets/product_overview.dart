import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/app_constants.dart';
import '../../../configs/defaults.dart';
import '../../../configs/ghaps.dart';
import '../../../configs/routes.dart';
import '../../../responsive.dart';
import '../../../widgets/custom_date_range.dart';
import '../../../widgets/section_title.dart';


class ProductOverviews extends StatefulWidget {
  const ProductOverviews({super.key});

  @override
  State<ProductOverviews> createState() => _ProductOverviewsState();
}

class _ProductOverviewsState extends State<ProductOverviews> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
    // controller.fetchAllBuildingSalesDateRange(
    //     startDate: startDate, endDate: endDate);
  }

  Future<void> _selectDateRange(StateSetter setState) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end: endDate ?? DateTime.now(),
      ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        AppRoutes.pop(context);
      });
      // Add your controller method here

      reportController.fetchAllBuildingSalesDateRange(
          startDate: startDate, endDate: endDate);
    }
  }


  void _showFilterMenu(BuildContext context, Offset offset) async {
    final screenSize = MediaQuery.of(context).size;
    final left = offset.dx;
    final top = offset.dy;
    final right = screenSize.width - left;
    final bottom = screenSize.height - top;

    await showMenu(
      color: const Color.fromARGB(255, 248, 248, 248),
      context: context,
      position: RelativeRect.fromLTRB(left, top, right, bottom),
      items: [
        PopupMenuItem(
          padding: const EdgeInsets.all(0),
          enabled: false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return  MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 10, left: 20, right: 10),
                      decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color.fromARGB(255, 248, 248, 248),
                      ),
                      child: const Text('Filter'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomDateRange(
                                  label: "Start Date",
                                  date: startDate,
                                  onTap: () => _selectDateRange(setState),
                                ),
                                const SizedBox(height: 10),
                                CustomDateRange(
                                  label: "End Date",
                                  date: endDate,
                                  onTap: () => _selectDateRange(setState),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                startDate = DateTime(now.year, now.month, 1);
                                endDate = DateTime(now.year, now.month + 1, 0);
                                reportController.fetchAllBuildingSalesDateRange(
                                    startDate: startDate, endDate: endDate);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: const BoxDecoration(
        color: AppColors.bgSecondayLight,
        borderRadius:
        BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
      ),
      child:  Column(
        children: [
          Row(
            children: [
              const SectionTitle(
                title: "Building Sales views",
                color: AppColors.secondaryLavender,
              ),   const Spacer(),
              MouseRegion(
                cursor: SystemMouseCursors.click, // Change this to the desired cursor type
                child: InkWell(
                  onTapDown: (TapDownDetails details) {
                    _showFilterMenu(context, details.globalPosition);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: const Color.fromARGB(38, 0, 0, 0), width: 0.3),
                    ),
                    child: const Row(
                      children: [
                        Icon(Iconsax.setting_3, size: 20, color: AppColors.primary),
                        SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Filter",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )


            ],
          ),
          gapH24,
          const BuildingSalesViewReport(),
        ],
      ),
    );
  }
}

class BarChartSample8 extends StatefulWidget {
  const BarChartSample8({super.key});

  final Color barBackgroundColor = AppColors.bgSecondayLight;
  final Color barColor = AppColors.secondaryMintGreen;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample8> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // padding: const EdgeInsets.all(16),
      height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Icon(Icons.graphic_eq),
          //     const SizedBox(
          //       width: 32,
          //     ),
          //     Text(
          //       'Sales forecasting chart',
          //       style: TextStyle(
          //         color: widget.barColor,
          //         fontSize: 18,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 32,
          // ),
          Expanded(
            child: BarChart(
              randomData(),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y,
      ) {
    return BarChartGroupData(
      x: x + 22,
      barRods: [
        BarChartRodData(
          toY: y,
          color: (x % 2 == 0)
              ? AppColors.secondaryPeach
              : (x % 3 == 0)
              ? AppColors.primary
              : widget.barColor,
          borderRadius: BorderRadius.circular(2),
          // borderDashArray: x >= 4 ? [4, 4] : null,
          width: Responsive.isMobile(context) ? 20 : 40,
          borderSide: BorderSide(
            color: (x % 2 == 0)
                ? AppColors.secondaryPeach
                : (x % 3 == 0)
                ? AppColors.primary
                : widget.barColor,
            width: 2.0,
          ),
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      // color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    Widget text = Text(
      days[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      maxY: 30.0,
      // minX: 0,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          direction: TooltipDirection.auto,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            // getTitlesWidget: getTitles,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              axisSide: AxisSide.bottom,
              child: Text(value.toString()),
            ),
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 38,
            showTitles: true,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        7,
            (i) => makeGroupData(
          i,
          Random().nextInt(20).toDouble() + 10,
        ),
      ),
      gridData: const FlGridData(show: true, drawVerticalLine: false),
    );
  }
}

class BuildingSalesViewReport extends StatefulWidget {
  const BuildingSalesViewReport({super.key});

  // Define bar chart color properties
  final Color barBackgroundColor = AppColors.bgSecondayLight;
  final Color barColor = AppColors.secondaryMintGreen;

  @override
  State<BuildingSalesViewReport> createState() => _BuildingSalesViewReportState();
}

class _BuildingSalesViewReportState extends State<BuildingSalesViewReport> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
        border: Border.all(width: 2, color: AppColors.highlightLight),
      ),
      height: 320,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // BarChart displaying dynamic data
          Obx(() => Expanded(
            child: BarChart(dynamicData()),
          )),
        ],
      ),
    );
  }

  // Function to generate BarChartGroupData for each bar
  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: (x % 2 == 0)
              ? AppColors.secondaryPeach
              : (x % 3 == 0)
              ? AppColors.primary
              : widget.barColor,
          borderRadius: BorderRadius.circular(2),
          width: Responsive.isMobile(context) ? 20 : 40,
        ),
      ],
    );
  }

  // Function to build the BarChart with dynamic data
  BarChartData dynamicData() {
    return BarChartData(
      maxY: reportController.salesDataReport.isNotEmpty
          ? reportController.salesDataReport.reduce((a, b) => a > b ? a : b) + 10 // Dynamic max value based on sales data
          : 30, // Default max value if no sales data available
      barTouchData: BarTouchData(
        enabled: true, // Enable touch interaction on the bar chart
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final int index = value.toInt();
              // Ensure the index is within the bounds of the sales data list
              if (index < reportController.salesDataReport.length) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text('Day ${index + 1}'), // Display 'Day' followed by the correct index
                );
              } else {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: const Text(''), // Display nothing if the index is out of bounds
                );
              }
            },
            reservedSize: 38, // Space reserved for the bottom titles
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 38,
            showTitles: true, // Display titles on the left side (Y-axis)
          ),
        ),
      ),
      borderData: FlBorderData(show: false), // Disable the border around the chart
      barGroups: List.generate(
        reportController.salesDataReport.length,
            (i) => makeGroupData(i, reportController.salesDataReport[i]), // Generate bar data for each day
      ),
      gridData: const FlGridData(
        show: true,
        drawVerticalLine: false, // Disable vertical grid lines
      ),
    );
  }
}


