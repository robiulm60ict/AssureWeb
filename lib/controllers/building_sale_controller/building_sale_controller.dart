import 'dart:io';

import 'package:assure_apps/configs/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/buliding_model.dart';
import '../../view/building_sale/sale_view/sale_view.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/snackbar.dart';

class BuildingSaleController extends GetxController {
  var projects = <BuildingModel>[].obs;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController amountInstallmentController =
      TextEditingController();
  final TextEditingController installmentCountController =
      TextEditingController();
  final TextEditingController paymentBookingPercentageCountController =
      TextEditingController();
  final TextEditingController dueAmount = TextEditingController();
  final TextEditingController percentageAmountController =
      TextEditingController();

  var totalAmount = 0.0.obs;

  // var paymentBookingPercentageCount = 0.0.obs;
  var result = 0.0.obs;
  var percentageAmount = 0.0.obs;

  double calculateResult(double totalAmount) {
    // Get the percentage input from the TextEditingController as text
    String paymentPercentageText = paymentBookingPercentageCountController.text;

    // Check if the input is either empty or not a valid number
    if (paymentPercentageText.isEmpty ||
        double.tryParse(paymentPercentageText) == null) {
      // If invalid, set dueAmount to totalAmount
      dueAmount.text = totalAmount.toStringAsFixed(2);
      print(
          'Invalid or empty percentage input, dueAmount is set to totalAmount');

      // Store and return the totalAmount
      result.value = totalAmount;
      return result.value;
    }

    // If the percentage input is valid, parse it to a double
    double paymentBookingPercentage = double.parse(paymentPercentageText);

    // Calculate the percentage amount from the totalAmount
    percentageAmount.value = totalAmount * paymentBookingPercentage / 100;

    // Calculate the due amount (remaining amount after the percentage is deducted)
    double due = totalAmount - percentageAmount.value;

    // Update the dueAmount TextEditingController to display the due amount
    dueAmount.text = due.toStringAsFixed(2);

    // Display the percentage amount (paymentBookingPercentage% of totalAmount)
    percentageAmountController.text = percentageAmount.toStringAsFixed(2);
    print('$paymentBookingPercentage% of Total Amount: $percentageAmount');

    // Store and return the calculated due amount
    result.value = due;
    print('Calculated due amount: $due');

    return result.value;
  }

  double calculateInstalmentAmountResult(double totalAmount) {
    // Get the percentage input and installment count as text
    String paymentPercentageText = paymentBookingPercentageCountController.text;
    String installmentCountText = installmentCountController.text;

    // Calculate the due amount based on the percentage input
    double due = totalAmount; // Default to totalAmount
    if (paymentPercentageText.isNotEmpty &&
        double.tryParse(paymentPercentageText) != null) {
      double paymentBookingPercentage = double.parse(paymentPercentageText);
      due = totalAmount - (totalAmount * paymentBookingPercentage / 100);
      print('Calculated due amount: $due');
    } else {
      print(
          'Invalid or empty percentage input, dueAmount is set to totalAmount');
    }

    // Update the dueAmount TextEditingController
    dueAmount.text = due.toStringAsFixed(2);

    // Calculate installment amount if the installment count is valid
    if (installmentCountText.isNotEmpty &&
        int.tryParse(installmentCountText) != null) {
      int installmentCount = int.parse(installmentCountText);
      if (installmentCount > 0) {
        double installment = due / installmentCount;
        print('Installment amount: $installment');
        amountInstallmentController.text = installment.toStringAsFixed(2);
        return installment;
      } else {
        print('Installment count must be greater than 0');
      }
    } else {
      print('Invalid or empty installment count');
    }

    // Return the due amount if no valid installment was calculated
    result.value = due;
    print(result.value);
    return result.value;
  }

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerPhoneController = TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController handoverDateController = TextEditingController();
  final TextEditingController installmentDateController =
      TextEditingController();
  final TextEditingController customerAddressController =
      TextEditingController();

  var imageUrl = "";

  @override
  void onInit() {
    super.onInit();

    fetchAllBuildingSales(); // Fetch projects on initialization
  }

  clearData() {
    paymentBookingPercentageCountController.clear();
    customerNameController.clear();
    customerPhoneController.clear();
    customerEmailController.clear();
    installmentDateController.clear();
    handoverDateController.clear();
    amountInstallmentController.clear();
    installmentDateController.clear();
    installmentCountController.clear();
    customerAddressController.clear();
    dueAmount.clear();
    percentageAmountController.clear();
  }

  @override
  void onClose() {
    // Dispose of the controllers

    super.onClose();
  }

  var buildingSales = <Map<String, dynamic>>[].obs;

// Fetch all building sales data
  Future<void> fetchAllBuildingSales() async {
    try {
      // Fetch all building sale documents
      QuerySnapshot buildingSaleSnapshot =
          await fireStore.collection('buildingSale').get();
      List<Map<String, dynamic>> allBuildingSales = [];

      for (var doc in buildingSaleSnapshot.docs) {
        // Get document ID
        String documentId = doc.id;
        Map<String, dynamic> buildingSaleData =
            doc.data() as Map<String, dynamic>;
        String? customerId = buildingSaleData["customerId"];
        String? buildingId = buildingSaleData[
            "buildingId"]; // Get the buildingId from the building sale data

        // Fetch customer data using the customer ID
        DocumentSnapshot customerDoc =
            await fireStore.collection('customer').doc(customerId).get();
        Map<String, dynamic>? customerData;

        if (customerDoc.exists) {
          customerData = customerDoc.data() as Map<String, dynamic>;
        } else {
          print("Customer not found for ID: $customerId");
          customerData = {}; // Initialize as empty map if not found
        }

        // Fetch building data using the building ID
        DocumentSnapshot buildingDoc =
            await fireStore.collection('building').doc(buildingId).get();
        Map<String, dynamic>? buildingData;

        if (buildingDoc.exists) {
          buildingData = buildingDoc.data() as Map<String, dynamic>;
        } else {
          print("Building not found for ID: $buildingId");
          buildingData = {}; // Initialize as empty map if not found
        }

        // Combine the building sale, customer, and building data
        allBuildingSales.add({
          "documentId": documentId, // Add document ID to the map
          "buildingSale": buildingSaleData,
          "customer": customerData,
          "building": buildingData, // Add building data to the map
        });
      }

      // Update the reactive variable
      buildingSales.value = allBuildingSales;
    } catch (e) {
      print("Error fetching building sales data: $e");
    }
  }

  var buildingSaleData = <String, dynamic>{}.obs; // Observable map for building sale data
  var isLoading = true.obs; // Observable loading state

  // Method to fetch building sale details using documentId
  Future<void> fetchSingleBuildingSale(String documentId) async {
    isLoading.value = true; // Set loading to true
    try {
      final data = await _fetchSingleBuildingSaleFromFirestore(documentId);
      if (data != null) {
        buildingSaleData.value = data; // Set fetched data to observable
      } else {
        print("No data found for document ID: $documentId");
      }
    } catch (error) {
      // Handle error if needed
      print("Error fetching building sale: $error");
    } finally {
      isLoading.value = false; // Set loading to false after fetching
    }
  }

  // Private method to handle fetching from Firestore
  Future<Map<String, dynamic>?> _fetchSingleBuildingSaleFromFirestore(String documentId) async {
    try {
      DocumentSnapshot doc = await fireStore.collection('buildingSale').doc(documentId).get();

      if (doc.exists) {
        Map<String, dynamic> buildingSaleData = doc.data() as Map<String, dynamic>;
        String? customerId = buildingSaleData["customerId"];
        String? buildingId = buildingSaleData["buildingId"];

        // Fetch customer data
        DocumentSnapshot customerDoc = await fireStore.collection('customer').doc(customerId).get();
        Map<String, dynamic>? customerData = customerDoc.exists
            ? customerDoc.data() as Map<String, dynamic>
            : null;

        // Fetch building data
        DocumentSnapshot buildingDoc = await fireStore.collection('building').doc(buildingId).get();
        Map<String, dynamic>? buildingData = buildingDoc.exists
            ? buildingDoc.data() as Map<String, dynamic>
            : null;

        // Combine data into one map
        return {
          "documentId": documentId,
          "buildingSale": buildingSaleData,
          "customer": customerData,
          "building": buildingData,
        };
      } else {
        print("Building sale not found for ID: $documentId");
        return null;
      }
    } catch (e) {
      print("Error fetching single building sale data: $e");
      return null;
    }
  }

  RxList<Map<String, dynamic>> installmentPlan = <Map<String, dynamic>>[].obs;

  void installmentNumberData() {
    // Clear previous installment plans if necessary
    installmentPlan.clear();

    int installmentCount = int.tryParse(installmentCountController.text) ?? 0;

    // Get the base due date from the controller
    String baseDueDate =
        installmentDateController.text; // Expecting format "YYYY-MM-DD"

    // Ensure the base date is not empty or invalid
    if (baseDueDate.isEmpty) {
      print("No base due date provided.");
      return;
    }

    // Generate installment plan based on installment count
    for (int i = 0; i < installmentCount; i++) {
      // Parse the baseDueDate
      DateTime? baseDate = DateTime.tryParse(baseDueDate);
      if (baseDate == null) {
        print("Invalid base due date format.");
        return;
      }

      // Set the installment due date based on the base date
      DateTime installmentDate =
          DateTime(baseDate.year, baseDate.month + i, baseDate.day);

      // Format the due date as "YYYY-MM-DD"
      String dueDate = installmentDate.toIso8601String().substring(0, 10);

      // Fetch the amount dynamically from the controller
      double amount = double.tryParse(amountInstallmentController.text) ?? 0.0;

      // Create the installment entry
      var installmentEntry = {
        "id": i + 1,
        "dueDate": dueDate,
        "amount": amount,
        "status": "Unpaid",
      };

      // Add to the installment plan list
      installmentPlan.add(installmentEntry);

      // Print the installment entry for debugging
      print("Installment Entry: $installmentEntry");
    }

    // Print the entire installment plan after creation
    print("Complete Installment Plan: $installmentPlan");
  }

// Date picker function to handle user input

  // await updateInstallmentPlanStatus('YOUR_DOCUMENT_ID', 2, 'completed');

  Future<void> updateInstallmentPlanStatus(String documentId,singleDocumentId, int installmentId,
      String newStatus, BuildContext context, dueAmount) async {
    try {
      // Reference to the document in Firestore
      DocumentReference docRef =
          fireStore.collection('buildingSale').doc(documentId);

      // Fetch the current data of the document
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Get the current installment plan
        List<dynamic> installmentPlan = docSnapshot['installmentPlan'];

        // Find the installment entry with the specified id and update its status
        for (var entry in installmentPlan) {
          if (entry['id'] == installmentId) {
            entry['status'] = newStatus; // Update the status
            break; // Exit the loop once the entry is found and updated
          }
        }

        // Update the document in Firestore with the new installment plan
        await docRef.update({
          'installmentPlan': installmentPlan,
          'dueAmount': dueAmount,
        });

        fetchSingleBuildingSale(documentId);
        fetchAllBuildingSales();
        // Navigator.pop(context);
        print("Installment plan with id $installmentId updated successfully.");
      } else {
        print("Document does not exist.");
      }
    } catch (e) {
      print("Failed to update installment plan: $e");
    }
  }

  Future<void> uploadBuildingStates(
    String documentId,
    String newStatus,
  ) async {
    try {
      // Reference to the document in Firestore
      DocumentReference docRef =
          fireStore.collection('building').doc(documentId);

      // Fetch the current data of the document
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update the status field
        await docRef.update({
          'status': newStatus,
        }); // Set new status here

        print("Building status updated successfully to $newStatus.");
        // successSnackBar(title: "Success", "Building status updated to $newStatus."); // Show success message
      } else {
        print("Document does not exist.");
        wrongSnackBar(title: "Error", "Document does not exist.");
      }
    } catch (e) {
      print("Failed to update building status: $e");
      wrongSnackBar(title: "Exception", "Failed to update building status: $e");
    }
  }

  Future<void> uploadImageAndCreateBuildingSale(String buildingId,
      String? imagePath, BuildContext context, grandTotal) async {
    appLoader(context, "Building Sale, please wait...");

    try {
      // Await the customer ID from the customer creation function
      String? customerId =
          await uploadImageAndCreateCustomer(imagePath, context);

      // Prepare the body for building sale
      Map<String, dynamic> body = {
        "buildingId": buildingId,
        "customerId": customerId,
        "installmentCount": installmentCountController.text,
        "bookDownPayment": percentageAmount.value,
        "handoverDate": handoverDateController.text,
        "installmentPlan": installmentPlan,
        "bookingPaymentPercent": paymentBookingPercentageCountController.text,
        "dueAmount": dueAmount.text,
        "totalCost": grandTotal ?? 0.0,
        "status": "Pending",
        "handOverDate": handoverDateController.text
      };

      print(body);
      // Save the building sale to Firestore
      DocumentReference docRef =
          await fireStore.collection('buildingSale').add(body);
      uploadBuildingStates(buildingId, "Book");
      createSaleReport(context,buildingId: buildingId,customerId: customerId,amount:percentageAmount.value,paymentType: "Booking" );

      buildingController.fetchProjects();
      clearData();
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => BuildingSalesScreen()));
      // context.go("/buildingView");
      successSnackBar("Building Sale created successfully!");
    } catch (e, stackTrace) {
      Navigator.pop(context);
      wrongSnackBar(title: "Exception", "Failed to create building sale: $e");
      print("Error adding building sale: $e");
      print("StackTrace: $stackTrace");
    }
  }

  Future createSaleReport(
       BuildContext context, {buildingId, customerId,amount,paymentType}) async {
    // appLoader(context, "Creating Sale Report, please wait...");

    try {


      // Prepare customer data to be saved
      Map<String, dynamic> customerBody = {
        "buildingId": buildingId,
        "customerId": customerId,
        "DateTime": DateTime.now(),
        "Amount": amount,
        "paymentType":paymentType,



      };

      // Save the customer to Firestore
      DocumentReference docRef =
      await fireStore.collection('BookingSalePaymentReport').add(customerBody);

      // Navigator.pop(context);
      // successSnackBar("Customer created successfully!");

      // Return the created customer ID
    } catch (e, stackTrace) {
      Navigator.pop(context);
      // wrongSnackBar(title: "Exception", "Failed to create customer: $e");
      print("Error adding customer: $e");
      print("StackTrace: $stackTrace");
      return null; // Return null if there was an error
    }
  }

  Future<String?> uploadImageAndCreateCustomer(
      String? imagePath, BuildContext context) async {
    // appLoader(context, "Creating Customer, please wait...");

    try {
      String? imageUrl;

      // Upload image to Firebase Storage if imagePath is provided
      if (imagePath != null && imagePath.isNotEmpty) {
        imageUrl = await uploadImageToFirebase(imagePath);
      } else {
        print('No image path provided; skipping image upload.');
      }

      // Prepare customer data to be saved
      Map<String, dynamic> customerBody = {
        "name": customerNameController.text,
        "image": imageUrl,
        "phone": customerPhoneController.text,
        "email": customerEmailController.text,
        "address": customerAddressController.text,
      };

      // Save the customer to Firestore
      DocumentReference docRef =
          await fireStore.collection('customer').add(customerBody);

      // Navigator.pop(context);
      successSnackBar("Customer created successfully!");

      // Return the created customer ID
      return docRef.id;
    } catch (e, stackTrace) {
      Navigator.pop(context);
      wrongSnackBar(title: "Exception", "Failed to create customer: $e");
      print("Error adding customer: $e");
      print("StackTrace: $stackTrace");
      return null; // Return null if there was an error
    }
  }

  Future<String?> uploadImageToFirebase(String imagePath) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Create a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference imageRef = storageRef.child('customer_images/$fileName.jpg');

      print("Starting image upload...");

      // Upload the image file to Firebase Storage
      UploadTask uploadTask = imageRef.putFile(File(imagePath));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print(
            'Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
      });

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await snapshot.ref.getDownloadURL();
      print("Image uploaded successfully. URL: $imageUrl");
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
