import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BuildingSalePaymentReportController extends GetxController {
  var buildingSales = <Map<String, dynamic>>[].obs;
  var buildingSalesReport = <Map<String, dynamic>>[].obs;

  var isDateFilterLoading=false.obs;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // Holds sales data for the chart
  var salesData =
      <double>[].obs; // List of sales amounts for each day or interval

  @override
  void onInit() {
    super.onInit();
    fetchAllBuildingSales(); // Fetch data on initialization
  }

  var totalSalesAmount=0.0.obs;
  Future<void> fetchAllBuildingSales() async {
    try {
      QuerySnapshot buildingSaleSnapshot =
      await fireStore.collection('BookingSalePaymentReport').get();
      List<Map<String, dynamic>> allBuildingSales = [];
      Map<int, double> dailySales = {}; // To store sales amount by day (or week)
      double totalAmount = 0.0; // Initialize total amount

      for (var doc in buildingSaleSnapshot.docs) {
        String documentId = doc.id;
        Map<String, dynamic> buildingSaleData =
        doc.data() as Map<String, dynamic>;
        double amount = double.parse(
            buildingSaleData['Amount'].toString()); // Parse the amount
        Timestamp date = buildingSaleData['DateTime']; // Get the sale date

        // Assuming you want to group sales by day:
        int dayOfYear = date.toDate().day; // Grouping by day of year

        // Add sales to the respective day
        if (dailySales.containsKey(dayOfYear)) {
          dailySales[dayOfYear] = dailySales[dayOfYear]! + amount;
        } else {
          dailySales[dayOfYear] = amount;
        }

        // Add to total amount
        totalAmount += amount;

        // You can also include customer and building data if needed
        String? customerId = buildingSaleData["customerId"];
        String? buildingId = buildingSaleData["buildingId"];
        DocumentSnapshot customerDoc =
        await fireStore.collection('customer').doc(customerId).get();
        DocumentSnapshot buildingDoc =
        await fireStore.collection('building').doc(buildingId).get();
        Map<String, dynamic>? customerData = customerDoc.exists
            ? customerDoc.data() as Map<String, dynamic>
            : {};
        Map<String, dynamic>? buildingData = buildingDoc.exists
            ? buildingDoc.data() as Map<String, dynamic>
            : {};

        allBuildingSales.add({
          "documentId": documentId,
          "SalePaymentReport": buildingSaleData,
          "customer": customerData,
          "building": buildingData,
        });
      }

      // Convert daily sales map to list for the chart
      salesData.value = dailySales.values.toList();

      // Set the fetched sales data and total amount
      buildingSales.value = allBuildingSales;
      totalSalesAmount.value = totalAmount; // Assuming totalSalesAmount is a variable in your state management
    } catch (e) {
      print("Error fetching building sales data: $e");
    }
  }

  Future<void> fetchAllBuildingSalesDateRange({
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    isDateFilterLoading.value = true;
    print("Start Date: $startDate");
    print("End Date: $endDate");

    // Ensure startDate and endDate are not null
    if (startDate == null || endDate == null) {
      print("Start date or end date is null");
      isDateFilterLoading.value = false;
      return;
    }

    try {
      // Convert the endDate to the end of the day (23:59:59)
      DateTime endOfDay = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      );

      // Firestore query to filter sales based on the given date range
      QuerySnapshot buildingSaleSnapshot = await fireStore
          .collection('BookingSalePaymentReport')
          .where('DateTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate.toUtc()))
          .where('DateTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay.toUtc()))
          .get();

      List<Map<String, dynamic>> allBuildingSales = [];
      Map<String, double> dailySales = {}; // Group sales by date

      for (var doc in buildingSaleSnapshot.docs) {
        String documentId = doc.id;
        Map<String, dynamic> buildingSaleData = doc.data() as Map<String, dynamic>;
        double amount = double.parse(buildingSaleData['Amount'].toString());
        Timestamp date = buildingSaleData['DateTime'];

        // Format date as a string for daily grouping
        String saleDateString = date.toDate().toIso8601String().split("T")[0];
        print(saleDateString);

        // Add sales to the respective date
        dailySales[saleDateString] = (dailySales[saleDateString] ?? 0) + amount;

        // Fetch additional customer and building data if needed
        String? customerId = buildingSaleData["customerId"];
        String? buildingId = buildingSaleData["buildingId"];
        DocumentSnapshot customerDoc = await fireStore.collection('customer').doc(customerId).get();
        DocumentSnapshot buildingDoc = await fireStore.collection('building').doc(buildingId).get();
        Map<String, dynamic>? customerData = customerDoc.exists
            ? customerDoc.data() as Map<String, dynamic>
            : {};
        Map<String, dynamic>? buildingData = buildingDoc.exists
            ? buildingDoc.data() as Map<String, dynamic>
            : {};

        allBuildingSales.add({
          "documentId": documentId,
          "SalePaymentReport": buildingSaleData,
          "customer": customerData,
          "building": buildingData,
        });
      }

      // Convert daily sales map to a list for the chart
      salesData.value = dailySales.values.toList();
      isDateFilterLoading.value = false;

      // Update the building sales list
      print( buildingSalesReport.value.length);
      buildingSalesReport.value = allBuildingSales;
    } catch (e) {
      isDateFilterLoading.value = false;
      print("Error fetching building sales data: $e");
    }
  }


}
