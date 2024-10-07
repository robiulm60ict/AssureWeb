import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BuildingSalePaymentReportController extends GetxController {
  var buildingSales = <Map<String, dynamic>>[].obs;
  var buildingSalesReport = <Map<String, dynamic>>[].obs;

  var isDateFilterLoading=false.obs;
  var isDateLoading=false.obs;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Holds sales data for the chart
  var salesData = <double>[].obs; // List of sales amounts for each day or interval
  var salesDataReport = <double>[].obs; // List of sales amounts for each day or interval
  DateTime? startDate;
  DateTime? endDate;
  DateTime now = DateTime.now();
  @override
  void onInit() {
    super.onInit();
    startDate = DateTime(now.year, now.month, 1);
    endDate = DateTime(now.year, now.month + 1, 0);
    fetchAllBuildingSalesDateRange(
        startDate: startDate, endDate: endDate);

    fetchAllBuildingSales();
    // Fetch data on initialization
  }

  RxDouble totalAmount = 0.0.obs; // To hold the total amount
  RxDouble totalSalesAmount = 0.0.obs; // To hold the total amount
  String valueData = "All time"; // Initialize with a default value
  Future<void> fetchAllBuildingSales({String dateFilter = "All time"}) async {
    try {
      isDateLoading.value = true;
      QuerySnapshot buildingSaleSnapshot;

      // Get the current date to filter based on time periods
      DateTime now = DateTime.now();

      if (dateFilter == "This year") {
        // Filter for sales within this year
        DateTime startOfYear = DateTime(now.year, 1, 1);
        buildingSaleSnapshot = await fireStore
            .collection('BookingSalePaymentReport')
            .orderBy('DateTime')
            .where('DateTime', isGreaterThanOrEqualTo: startOfYear)
            .get();
      } else if (dateFilter == "Month") {
        // Filter for sales within this month
        DateTime startOfMonth = DateTime(now.year, now.month, 1);
        buildingSaleSnapshot = await fireStore
            .collection('BookingSalePaymentReport')
            .orderBy('DateTime')
            .where('DateTime', isGreaterThanOrEqualTo: startOfMonth)
            .get();
      } else if (dateFilter == "Week") {
        // Filter for sales within this week
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        buildingSaleSnapshot = await fireStore
            .collection('BookingSalePaymentReport')
            .orderBy('DateTime')
            .where('DateTime', isGreaterThanOrEqualTo: startOfWeek)
            .get();
      } else {
        // No filtering, get all sales
        buildingSaleSnapshot =
        await fireStore.collection('BookingSalePaymentReport').get();
      }

      List<Map<String, dynamic>> allBuildingSales = [];
      Map<int, double> dailySales = {}; // To store sales amount by day (or week)
      double totalAmount = 0.0; // Initialize total amount

      for (var doc in buildingSaleSnapshot.docs) {
        String documentId = doc.id;
        Map<String, dynamic> buildingSaleData =
        doc.data() as Map<String, dynamic>;

        // Ensure fields 'Amount' and 'DateTime' exist
        double? amount = buildingSaleData['Amount'] != null
            ? double.parse(buildingSaleData['Amount'].toString())
            : null;
        Timestamp? date = buildingSaleData['DateTime'];

        if (amount != null && date != null) {
          DateTime saleDate = date.toDate();

          // Grouping by day of the year
          int dayOfYear = DateTime(saleDate.year, saleDate.month, saleDate.day)
              .difference(DateTime(saleDate.year))
              .inDays + 1;

          // Add sales to the respective day
          if (dailySales.containsKey(dayOfYear)) {
            dailySales[dayOfYear] = dailySales[dayOfYear]! + amount;
          } else {
            dailySales[dayOfYear] = amount;
          }

          totalAmount += amount;

          // Add the document to the buildingSales list
          allBuildingSales.add({
            "SalePaymentReport": buildingSaleData,
          });
        } else {
          print('Skipping invalid document: $buildingSaleData');
        }
      }

      // Update state with fetched data
      salesData.value = dailySales.values.toList();
      buildingSales.value = allBuildingSales;
      totalSalesAmount.value = totalAmount;

      print("buildingSales count: ${buildingSales.length}");
      print("Total amount: $totalAmount");

      isDateLoading.value = false;
    } catch (e) {
      isDateLoading.value = false;
      print("Error fetching building sales data: $e");
    }
  }

  var salesDates = <DateTime>[].obs; // Add this to store corresponding dates

  Future<void> fetchAllBuildingSalesDateRange({
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    isDateFilterLoading.value = true;
    totalAmount.value = 0; // Reset total amount before fetching new data
    salesDataReport.clear();
    salesDates.clear();
    buildingSalesReport.clear();

    print("Start Date: $startDate");
    print("End Date: $endDate");

    if (startDate == null || endDate == null) {
      print("Start date or end date is null");
      isDateFilterLoading.value = false;
      return;
    }

    try {
      DateTime endOfDay = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );

      QuerySnapshot buildingSaleSnapshot = await fireStore
          .collection('BookingSalePaymentReport')
          .orderBy('DateTime', descending: true) // Order by DateTime in descending order
          .where('DateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate.toUtc()))
          .where('DateTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay.toUtc()))
          .get();

      List<Map<String, dynamic>> allBuildingSales = [];
      Map<String, double> dailySales = {}; // Group sales by date

      // Collect customerIds and buildingIds for batch querying later
      Set<String> customerIds = {};
      Set<String> buildingIds = {};

      for (var doc in buildingSaleSnapshot.docs) {
        // Safely retrieve data
        var data = doc.data();
        if (data == null) {
          print("Warning: Document with ID ${doc.id} has no data. Skipping.");
          continue; // Skip this document
        }

        // Attempt to cast data to Map<String, dynamic>
        Map<String, dynamic> buildingSaleData;
        try {
          buildingSaleData = data as Map<String, dynamic>;
        } catch (e) {
          print("Error: Document with ID ${doc.id} has invalid data format. Skipping.");
          continue; // Skip this document
        }

        String? customerId = buildingSaleData["customerId"];
        String? buildingId = buildingSaleData["buildingId"];

        if (customerId != null) customerIds.add(customerId);
        if (buildingId != null) buildingIds.add(buildingId);

        // Safely parse the amount, handle potential errors
        double amount = double.tryParse(buildingSaleData['Amount'].toString()) ?? 0;
        totalAmount.value += amount; // Accumulate total amount

        Timestamp? timestamp = buildingSaleData['DateTime'];
        if (timestamp == null) {
          print("Warning: Document with ID ${doc.id} has no 'DateTime' field. Skipping date aggregation.");
          continue; // Skip date aggregation for this document
        }

        DateTime saleDate = timestamp.toDate();
        String saleDateString = saleDate.toIso8601String().split("T")[0];

        dailySales[saleDateString] = (dailySales[saleDateString] ?? 0) + amount;

        // Add the initial data
        allBuildingSales.add({
          "documentId": doc.id,
          "SalePaymentReport": buildingSaleData,
          "customer": null,  // Will fill after fetching customer data
          "building": null,  // Will fill after fetching building data
        });
      }

      // Sort the dailySales by date to ensure consistency
      var sortedEntries = dailySales.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      // Populate salesDataReport and salesDates
      for (var entry in sortedEntries) {
        salesDataReport.add(entry.value);
        salesDates.add(DateTime.parse(entry.key));
      }

      // Batch fetch customer and building data
      // Check if there are customerIds and buildingIds to fetch
      List<DocumentSnapshot> customerDocs = [];
      List<DocumentSnapshot> buildingDocs = [];

      if (customerIds.isNotEmpty) {
        try {
          customerDocs = await Future.wait(
            customerIds.map((id) => fireStore.collection('customer').doc(id).get()),
          );
        } catch (e) {
          print("Error fetching customer data: $e");
        }
      } else {
        print("No customer IDs found to fetch.");
      }

      if (buildingIds.isNotEmpty) {
        try {
          buildingDocs = await Future.wait(
            buildingIds.map((id) => fireStore.collection('building').doc(id).get()),
          );
        } catch (e) {
          print("Error fetching building data: $e");
        }
      } else {
        print("No building IDs found to fetch.");
      }

      // Map fetched data by ID for quick lookup
      Map<String, Map<String, dynamic>> customerDataMap = {};
      for (var doc in customerDocs) {
        var data = doc.data();
        if (data != null) {
          try {
            customerDataMap[doc.id] = data as Map<String, dynamic>;
          } catch (e) {
            print("Error: Customer document with ID ${doc.id} has invalid data format.");
          }
        } else {
          print("Warning: Customer document with ID ${doc.id} has no data.");
        }
      }

      Map<String, Map<String, dynamic>> buildingDataMap = {};
      for (var doc in buildingDocs) {
        var data = doc.data();
        if (data != null) {
          try {
            buildingDataMap[doc.id] = data as Map<String, dynamic>;
          } catch (e) {
            print("Error: Building document with ID ${doc.id} has invalid data format.");
          }
        } else {
          print("Warning: Building document with ID ${doc.id} has no data.");
        }
      }

      // Update the sales list with fetched customer and building data
      for (var sale in allBuildingSales) {
        String? customerId = sale['SalePaymentReport']["customerId"];
        String? buildingId = sale['SalePaymentReport']["buildingId"];

        if (customerId != null && customerDataMap.containsKey(customerId)) {
          sale['customer'] = customerDataMap[customerId];
        } else {
          sale['customer'] = {}; // Or handle as per your requirement
          print("Warning: No customer data found for ID $customerId.");
        }

        if (buildingId != null && buildingDataMap.containsKey(buildingId)) {
          sale['building'] = buildingDataMap[buildingId];
        } else {
          sale['building'] = {}; // Or handle as per your requirement
          print("Warning: No building data found for ID $buildingId.");
        }
      }

      // Update the building sales list with enriched data
      buildingSalesReport.value = allBuildingSales;

      isDateFilterLoading.value = false;

      // Print or use the total amount
      print("Total Sales Amount: ${totalAmount.value}");

    } catch (e, stackTrace) {
      isDateFilterLoading.value = false;
      print("Error fetching building sales: $e");
      print("Stack Trace: $stackTrace");
    }
  }



}
