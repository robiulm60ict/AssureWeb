import 'package:assure_apps/configs/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../configs/app_colors.dart';

class RevenueData {
  final double amount;
  final DateTime date;

  RevenueData(this.amount, this.date);
}


class RevenueLineChart extends StatelessWidget {
  final List<RevenueData> revenueData;

  const RevenueLineChart({
    Key? key,
    required this.revenueData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData {
    // Generate a full list of months from the first to the last entry
    final fullRevenueData = generateFullRevenueData(revenueData);

    final spots = fullRevenueData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.amount))
        .toList();

    // Fallback value if fullRevenueData is empty
    final maxRevenue = fullRevenueData.isNotEmpty
        ? fullRevenueData.map((data) => data.amount).reduce((a, b) => a > b ? a : b)
        : 0.0;

    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData,
      borderData: borderData,
      lineBarsData: [lineChartBarData(spots)],
      minX: 0,
      maxX: fullRevenueData.length.toDouble() - 1,
      maxY: maxRevenue * 1.1, // Only multiply when there's data
      minY: 0, // Set minY to 0 for better display
    );
  }

  // Function to generate full list of months
  List<RevenueData> generateFullRevenueData(List<RevenueData> revenueData) {
    if (revenueData.isEmpty) return [];

    // Sort by date in case they are out of order
    revenueData.sort((a, b) => a.date.compareTo(b.date));

    DateTime currentDate = DateTime(revenueData.first.date.year, revenueData.first.date.month);
    DateTime lastDate = DateTime(revenueData.last.date.year, revenueData.last.date.month);

    List<RevenueData> fullRevenueData = [];
    int currentIndex = 0;

    while (currentDate.isBefore(lastDate) || currentDate.isAtSameMomentAs(lastDate)) {
      if (currentIndex < revenueData.length &&
          revenueData[currentIndex].date.year == currentDate.year &&
          revenueData[currentIndex].date.month == currentDate.month) {
        fullRevenueData.add(revenueData[currentIndex]);
        currentIndex++;
      } else {
        fullRevenueData.add(RevenueData(0, currentDate)); // Add a placeholder for missing months
      }

      // Move to next month
      currentDate = DateTime(currentDate.year, currentDate.month + 1);
    }

    return fullRevenueData;
  }

  LineTouchData get lineTouchData => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => AppColors.titleLight,
    ),
  );

  FlTitlesData get titlesData => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  LineChartBarData lineChartBarData(List<FlSpot> spots) {
    return LineChartBarData(
      isCurved: true,
      color: AppColors.primary,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return value % 20000 == 0
        ? Text(value.toInt().toString(), style: style, textAlign: TextAlign.center)
        : Container();
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 20000,
    reservedSize: 40,
  );


  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle();
    Widget text;

    if (value.toInt() < revenueData.length) {
      final date = revenueData[value.toInt()].date;
      String monthName = DateFormat('MMM').format(date); // Get the short month name
      text = Text(
        monthName,
        style: style,
      );
    } else {
      text = const Text('');
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: AppColors.highlightLight, width: 1),
      left: BorderSide.none,
      right: BorderSide.none,
      top: BorderSide.none,
    ),
  );
}


class SalesReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<RevenueData> revenueData = reportController.buildingSales
        .map((data) {
      // Check for null values before creating RevenueData
      final amount = data['SalePaymentReport']['Amount'];
      final date =  (data['SalePaymentReport']['DateTime'] as Timestamp).toDate();
      print("object ${data['SalePaymentReport']['Amount']}");

      if (amount != null && date != null) {
        return RevenueData(double.parse(amount.toString()), date);
      } else {
        // Log or handle the null case as needed
        print('Skipping entry with null values: $data');
        return null; // or handle as necessary
      }
    })
        .whereType<RevenueData>() // Filters out any null entries
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [

            Expanded(
              child: RevenueLineChart(revenueData: revenueData), // Pass revenueData here
            ),
          ],
        ),
      ),
    );
  }
}
