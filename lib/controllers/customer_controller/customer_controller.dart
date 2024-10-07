
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/customer_model.dart';

class CustomerController extends GetxController {
  var customers = <CustomerModel>[].obs;
  var customersFilter = <CustomerModel>[].obs;
  var isLoading=false.obs;
  var isLoadingFilter=false.obs;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  var imageUrl="";

  @override
  void onInit() {
    super.onInit();

    fetchCustomer();
    fetchCustomerFilter(dateFilter:"All time" );// Fetch projects on initialization
  }



  void fetchCustomer() async {
    try {
      isLoading.value = true; // Start loading
      final snapshot = await fireStore.collection('customer')
          
          .orderBy("DateTime",descending: true)
          .get();

      // Map the documents to BuildingModel instances
      customers.value = snapshot.docs
          .map((doc) => CustomerModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Optionally, you can print the fetched projects for debugging
      print("Fetched customers: ${customers.length}");

    } catch (e) {
      // Handle any errors that occur during fetching
      print("Error fetching projects: $e");
      // Optionally, you can show an error message to the user
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  void fetchCustomerFilter({String dateFilter = "All time"}) async {
    try {
      isLoadingFilter.value = true; // Start loading

      // Define date ranges based on the filter option
      DateTime now = DateTime.now();
      DateTime startDate;

      // Adjust the startDate based on the selected filter
      if (dateFilter == "This year") {
        startDate = DateTime(now.year, 1, 1); // Start of the year
      } else if (dateFilter == "Month") {
        startDate = DateTime(now.year, now.month, 1); // Start of the month
      } else if (dateFilter == "Week") {
        startDate = now.subtract(Duration(days: now.weekday - 1)); // Start of the week
      } else {
        startDate = DateTime(2000, 1, 1); // Default for "All time" (an arbitrary far-past date)
      }

      // Query Firestore based on the date range
      final snapshot = await fireStore
          .collection('customer')
          .where('DateTime', isGreaterThanOrEqualTo: startDate) // Assuming `createDateTime` field in Firestore
          .get();

      // Map the documents to CustomerModel instances
      customersFilter.value = snapshot.docs
          .map((doc) => CustomerModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Debugging: print the number of fetched customers
      print("Fetched customers: ${customersFilter.length}");
      isLoadingFilter.value = false;
    } catch (e) {
      isLoadingFilter.value = false;
      // Handle any errors that occur during fetching
      print("Error fetching customers: $e");
      // Optionally show an error message to the user
    } finally {
      isLoadingFilter.value = false; // Stop loading
    }
  }




}
