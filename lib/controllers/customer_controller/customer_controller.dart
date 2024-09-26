
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/customer_model.dart';

class CustomerController extends GetxController {
  var customers = <CustomerModel>[].obs;
  var isLoading=false.obs;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  var imageUrl="";

  @override
  void onInit() {
    super.onInit();

    fetchProjects(); // Fetch projects on initialization
  }



  void fetchProjects() async {
    try {
      isLoading.value = true; // Start loading
      final snapshot = await fireStore.collection('customer').get();

      // Map the documents to BuildingModel instances
      customers.value = snapshot.docs
          .map((doc) => CustomerModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Optionally, you can print the fetched projects for debugging
      print("Fetched Projects: ${customers.value.length}");

    } catch (e) {
      // Handle any errors that occur during fetching
      print("Error fetching projects: $e");
      // Optionally, you can show an error message to the user
    } finally {
      isLoading.value = false; // Stop loading
    }
  }



}
