
import 'package:assure_apps/configs/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class RevenueData {
  double amount;
  DateTime date;

  RevenueData(this.amount, this.date);
}

extension DateTimeExtension on DateTime {
  int get weekOfYear {
    // Using ISO week date
    final firstDayOfYear = DateTime(this.year, 1, 1);
    int daysOffset = firstDayOfYear.weekday - DateTime.monday;
    DateTime adjustedDate = this.subtract(Duration(days: daysOffset));
    int weekNumber = adjustedDate.difference(firstDayOfYear).inDays ~/ 7 + 1;
    return weekNumber;
  }
}

class RevenueLineChart extends StatelessWidget {
  final List<RevenueData> revenueData;
  final String dateFilter;

  const RevenueLineChart({
    Key? key,
    required this.revenueData,
    required this.dateFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      sampleData,
      // swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData {
    // Generate a full list of periods based on the filter
    final fullRevenueData = generateFullRevenueData(revenueData);

    final spots = fullRevenueData
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.amount))
        .toList();

    // Determine the maximum revenue for setting the chart's Y-axis
    final maxRevenue = fullRevenueData.isNotEmpty
        ? fullRevenueData.map((data) => data.amount).reduce((a, b) => a > b ? a : b)
        : 0.0;

    return LineChartData(
      lineTouchData: lineTouchData,
      gridData: gridData,
      titlesData: titlesData(fullRevenueData),
      borderData: borderData,
      lineBarsData: [lineChartBarData(spots)],
      minX: 0,
      maxX: (fullRevenueData.length - 1).toDouble(),
      maxY: maxRevenue * 1.1, // Add some padding to the top
      minY: 0, // Start Y-axis at 0
    );
  }

  // Function to generate full list based on filter
  List<RevenueData> generateFullRevenueData(List<RevenueData> revenueData) {
    if (revenueData.isEmpty) return [];

    // Sort the data by date
    revenueData.sort((a, b) => a.date.compareTo(b.date));

    List<RevenueData> fullRevenueData = [];

    switch (dateFilter) {
      case "This year":
      case "All time":
      // Group by month
        fullRevenueData = _groupByMonth(revenueData);
        break;

      case "Month":
      // Group by week within the month
        fullRevenueData = _groupByWeek(revenueData);
        break;

      case "Week":
      // Group by day within the current week
        fullRevenueData = _groupByDay(revenueData);
        break;

      default:
      // Default to grouping by month
        fullRevenueData = _groupByMonth(revenueData);
    }

    return fullRevenueData;
  }

  // Helper methods for grouping
  List<RevenueData> _groupByMonth(List<RevenueData> revenueData) {
    List<RevenueData> groupedData = [];
    int currentMonth = -1;
    double monthlyTotal = 0.0;
    DateTime? currentDate;

    for (var data in revenueData) {
      if (data.date.month != currentMonth) {
        if (currentMonth != -1) {
          groupedData.add(RevenueData(monthlyTotal, currentDate!));
        }
        currentMonth = data.date.month;
        monthlyTotal = data.amount;
        currentDate = DateTime(data.date.year, data.date.month);
      } else {
        monthlyTotal += data.amount;
      }
    }

    // Add the last month
    if (currentMonth != -1) {
      groupedData.add(RevenueData(monthlyTotal, currentDate!));
    }

    return groupedData;
  }

  List<RevenueData> _groupByWeek(List<RevenueData> revenueData) {
    List<RevenueData> groupedData = [];
    int currentWeek = -1;
    double weeklyTotal = 0.0;
    DateTime? currentDate;

    for (var data in revenueData) {
      int weekNumber = data.date.weekOfYear;

      if (weekNumber != currentWeek) {
        if (currentWeek != -1) {
          groupedData.add(RevenueData(weeklyTotal, currentDate!));
        }
        currentWeek = weekNumber;
        weeklyTotal = data.amount;
        currentDate = _startOfWeek(data.date);
      } else {
        weeklyTotal += data.amount;
      }
    }

    // Add the last week
    if (currentWeek != -1) {
      groupedData.add(RevenueData(weeklyTotal, currentDate!));
    }

    return groupedData;
  }

  List<RevenueData> _groupByDay(List<RevenueData> revenueData) {
    List<RevenueData> groupedData = [];
    DateTime startOfWeek = _startOfWeek(revenueData.first.date);
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    // Initialize the list with zero sales for each day
    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      groupedData.add(RevenueData(0.0, day));
    }

    // Sum the sales for each day
    for (var data in revenueData) {
      DateTime saleDate = data.date;
      if (!saleDate.isBefore(startOfWeek) && !saleDate.isAfter(endOfWeek)) {
        int index = saleDate.weekday - 1; // Monday = 1
        groupedData[index].amount += data.amount;
      }
    }

    return groupedData;
  }

  DateTime _startOfWeek(DateTime date) {
    // Assuming week starts on Monday
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
  }

  bool isSameWeek(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.weekOfYear == date2.weekOfYear;
  }

  LineTouchData get lineTouchData => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          String label;
          if (dateFilter == "All time" || dateFilter == "This year") {
            label = DateFormat('MMM yyyy').format(revenueData[spot.x.toInt()].date);
          } else if (dateFilter == "Month") {
            label = "Week ${spot.x.toInt() + 1}";
          } else if (dateFilter == "Week") {
            label = DateFormat('EEE').format(revenueData[spot.x.toInt()].date);
          } else {
            label = DateFormat('MMM').format(revenueData[spot.x.toInt()].date);
          }

          return LineTooltipItem(
            '$label\n${spot.y.toStringAsFixed(2)}',
            const TextStyle(color: Colors.white),
          );
        }).toList();
      },
    ),
  );

  FlTitlesData titlesData(List<RevenueData> fullRevenueData) => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (double value, TitleMeta meta) {
          if (value.toInt() < fullRevenueData.length) {
            final date = fullRevenueData[value.toInt()].date;
            String label;

            switch (dateFilter) {
              case "All time":
              case "This year":
                label = DateFormat('MMM').format(date);
                break;
              case "Month":
                label = 'W${value.toInt() + 1}';
                break;
              case "Week":
                label = DateFormat('EEE').format(date);
                break;
              default:
                label = DateFormat('MMM').format(date);
            }

            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 8,
              child: Text(label, style: TextStyle(fontSize: 10)),
            );
          } else {
            return Container();
          }
        },
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        interval: calculateYInterval(fullRevenueData),
        getTitlesWidget: (double value, TitleMeta meta) {
          return Text(
            '${_formatAmount(value)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  // Calculate Y-axis interval based on max revenue
  double calculateYInterval(List<RevenueData> fullRevenueData) {
    if (fullRevenueData.isEmpty) return 20000;
    double max = fullRevenueData.map((data) => data.amount).reduce((a, b) => a > b ? a : b);
    if (max <= 1000) return 200;
    if (max <= 10000) return 2000;
    return 20000;
  }

  // Format amount with commas
  String _formatAmount(double amount) {
    final formatter = NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '\$',
    );
    return formatter.format(amount);
  }

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Colors.grey, width: 1),
      left: BorderSide(color: Colors.grey, width: 1),
      right: BorderSide.none,
      top: BorderSide.none,
    ),
  );

  LineChartBarData lineChartBarData(List<FlSpot> spots) {
    return LineChartBarData(
      isCurved: true,
      color: Colors.blue,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: spots,
    );
  }
}


class SalesReportScreen extends StatefulWidget {
  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  // String valueData = "All time"; // Initialize with default value

  @override
  Widget build(BuildContext context) {
    List<RevenueData> revenueData = reportController.buildingSales
        .map((data) {

      print("data$data");
      // Check for null values before creating RevenueData
      final amount = data['SalePaymentReport']['Amount'];
      final date = (data['SalePaymentReport']['DateTime'] as Timestamp).toDate();
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
            // Expanded Line Chart
            Expanded(
              child: RevenueLineChart(
                revenueData: revenueData, // Pass revenueData here
                dateFilter:  reportController. valueData, // Pass the current filter
              ),
            ),
          ],
        ),
      ),
    );
  }
}
