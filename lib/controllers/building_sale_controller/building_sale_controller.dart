import 'dart:io';

import 'package:assure_apps/configs/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/buliding_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/snackbar.dart';
import 'dart:html' as html; // Import this for web compatibility

class BuildingSaleController extends GetxController {
  var projects = <BuildingModel>[].obs;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final TextEditingController amountInstallmentController =
      TextEditingController();
  final TextEditingController installmentCountController =
      TextEditingController();
  final TextEditingController paymentBookingPercentageCountController =
      TextEditingController();
  final TextEditingController dueAmount = TextEditingController();
  final TextEditingController percentageAmountController =
      TextEditingController();

  final TextEditingController totalDueAmount = TextEditingController();
  final TextEditingController totalDiscount = TextEditingController();
  final TextEditingController totalAllCalculationDiscount = TextEditingController();
  final TextEditingController dueAmountDiscountController = TextEditingController();

  var totalAmount = 0.0.obs;

  // var paymentBookingPercentageCount = 0.0.obs;
  var result = 0.0.obs;
  var percentageAmount = 0.0.obs;

  RxDouble discountTotalAmount=0.0.obs;
  var discountAmountTotal="0.0".obs;
  RxDouble discountDueAmount=0.0.obs;
  RxDouble discountDueTotalAmount=0.0.obs;


  // var paymentBookingPercentageCount = 0.0.obs;


  String selectedDiscountType = 'no';
  String selectTotalAmountDiscountType = 'fixed';
  String selectDueAmountDiscountType = 'fixed';
  double calculateInstalmentAmountResult(double totalAmount) {
    // Step 1: Apply total discount (if any)
    String discountText = totalDiscount.text;
    if (discountText.isNotEmpty && double.tryParse(discountText) != null) {
      // Parse the discount amount and clear due discount if needed
      dueAmountDiscountController.clear();
      discountTotalAmount.value = double.parse(discountText);

      // Apply discount as a percentage or fixed amount
      if (selectTotalAmountDiscountType == 'percent') {
        discountTotalAmount.value = totalAmount * (discountTotalAmount.value / 100);
      }
      totalAmount -= discountTotalAmount.value; // Apply discount to total amount
      discountAmountTotal.value=discountTotalAmount.value.toStringAsFixed(2);
      print('Discount applied: $discountText%');
      print('Discount amount: ${discountTotalAmount.value}');
      print('Total amount after discount: $totalAmount');
    }

    // Step 2: Calculate initial payment based on booking percentage
    double paymentBookingPercentage = double.tryParse(paymentBookingPercentageCountController.text) ?? 0.0;
    percentageAmount.value = totalAmount * paymentBookingPercentage / 100;

    double initialPayment = percentageAmount.value; // Initial payment
    print('Initial payment amount (based on $paymentBookingPercentage%): $initialPayment');

    // Step 3: Calculate due amount after initial payment
    double due = totalAmount - initialPayment;

    // Update controllers with the initial payment and due amount
    percentageAmountController.text = initialPayment.toStringAsFixed(2);
    dueAmount.text = due.toStringAsFixed(2);

    // Step 4: Apply due discount (if any)
    String dueDiscountText = dueAmountDiscountController.text;
    if (dueDiscountText.isNotEmpty && double.tryParse(dueDiscountText) != null) {
      discountDueAmount.value = double.parse(dueDiscountText);

      // Apply due discount as a percentage or fixed amount
      if (selectDueAmountDiscountType == 'percent') {
        discountDueAmount.value = due * (discountDueAmount.value / 100);
      }
      due -= discountDueAmount.value; // Apply discount to due amount
      totalDueAmount.text = due.toStringAsFixed(2);
      dueAmount.text = due.toStringAsFixed(2);
      print('Due discount applied: $dueDiscountText%');
      print('Due discount amount: ${discountDueAmount.value}');
      print('Due amount after due discount: $due');
    }

    // Step 5: Calculate installment amount if applicable
    String installmentCountText = installmentCountController.text;
    if (installmentCountText.isNotEmpty && int.tryParse(installmentCountText) != null) {

      discountDueTotalAmount.value=due;
      int installmentCount = int.parse(installmentCountText);
      if (installmentCount > 0) {
        double installment = due / installmentCount;
        amountInstallmentController.text = installment.toStringAsFixed(2);

        print('Installment amount: $installment');
        installmentNumberData();

        return installment;
      } else {
        print('Installment count must be greater than 0');
      }
    } else {
      print('Invalid or empty installment count');
    }
    // Step 6: Return the final due amount if no valid installment was calculated
    result.value = due;
    print('Final due amount: ${result.value}');
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
  var isLoadingSales=false.obs;

  Future<void> fetchAllBuildingSales() async {
    try {
      isLoadingSales.value = true;

      // Fetch all building sale documents
      QuerySnapshot buildingSaleSnapshot = await fireStore
          .collection('buildingSale')
          .orderBy('BookingDate')
          .get();

      List<Map<String, dynamic>> allBuildingSales = [];
      List<String> customerIds = [];
      List<String> buildingIds = [];

      for (var doc in buildingSaleSnapshot.docs) {
        String documentId = doc.id;
        Map<String, dynamic> buildingSaleData = doc.data() as Map<String, dynamic>;
        String? customerId = buildingSaleData["customerId"];
        String? buildingId = buildingSaleData["buildingId"];

        // Collect customer and building IDs
        if (customerId != null) customerIds.add(customerId);
        if (buildingId != null) buildingIds.add(buildingId);

        // Add initial building sale data to the list
        allBuildingSales.add({
          "documentId": documentId,
          "buildingSale": buildingSaleData,
          "customer": {}, // Placeholder for customer data
          "building": {}, // Placeholder for building data
        });
      }

      // Fetch customer data in bulk
      if (customerIds.isNotEmpty) {
        var customerDocs = await fireStore.collection('customer').where(FieldPath.documentId, whereIn: customerIds).get();
        for (var customerDoc in customerDocs.docs) {
          String customerId = customerDoc.id;
          Map<String, dynamic> customerData = customerDoc.data() as Map<String, dynamic>;

          // Update corresponding building sales with customer data
          for (var sale in allBuildingSales) {
            if (sale["buildingSale"]["customerId"] == customerId) {
              sale["customer"] = customerData;
            }
          }
        }
      }

      // Fetch building data in bulk
      if (buildingIds.isNotEmpty) {
        var buildingDocs = await fireStore.collection('building').where(FieldPath.documentId, whereIn: buildingIds).get();
        for (var buildingDoc in buildingDocs.docs) {
          String buildingId = buildingDoc.id;
          Map<String, dynamic> buildingData = buildingDoc.data() as Map<String, dynamic>;

          // Update corresponding building sales with building data
          for (var sale in allBuildingSales) {
            if (sale["buildingSale"]["buildingId"] == buildingId) {
              sale["building"] = buildingData;
            }
          }
        }
      }

      // Update the reactive variable
      buildingSales.value = allBuildingSales;

    } catch (e) {
      print("Error fetching building sales data: $e");
    } finally {
      isLoadingSales.value = false;
    }
  }

// Fetch all building sales data
//   Future<void> fetchAllBuildingSales() async {
//     try {
//       isLoadingSales.value=true;
//       // Fetch all building sale documents
//       QuerySnapshot buildingSaleSnapshot =
//           await fireStore.collection('buildingSale')
//               .orderBy('BookingDate')
//
//               .get();
//       List<Map<String, dynamic>> allBuildingSales = [];
//
//       for (var doc in buildingSaleSnapshot.docs) {
//         // Get document ID
//         String documentId = doc.id;
//         Map<String, dynamic> buildingSaleData =
//             doc.data() as Map<String, dynamic>;
//         String? customerId = buildingSaleData["customerId"];
//         String? buildingId = buildingSaleData[
//             "buildingId"]; // Get the buildingId from the building sale data
//
//         // Fetch customer data using the customer ID
//         DocumentSnapshot customerDoc =
//             await fireStore.collection('customer').doc(customerId).get();
//         Map<String, dynamic>? customerData;
//
//         if (customerDoc.exists) {
//           customerData = customerDoc.data() as Map<String, dynamic>;
//         } else {
//           isLoadingSales.value=false;
//
//           print("Customer not found for ID: $customerId");
//           customerData = {}; // Initialize as empty map if not found
//         }
//
//         // Fetch building data using the building ID
//         DocumentSnapshot buildingDoc =
//             await fireStore.collection('building').doc(buildingId).get();
//         Map<String, dynamic>? buildingData;
//
//         if (buildingDoc.exists) {
//           buildingData = buildingDoc.data() as Map<String, dynamic>;
//         } else {
//           print("Building not found for ID: $buildingId");
//           buildingData = {}; // Initialize as empty map if not found
//         }
//
//         // Combine the building sale, customer, and building data
//         allBuildingSales.add({
//           "documentId": documentId, // Add document ID to the map
//           "buildingSale": buildingSaleData,
//           "customer": customerData,
//           "building": buildingData, // Add building data to the map
//         });
//       }
//       isLoadingSales.value=false;
//
//       // Update the reactive variable
//       buildingSales.value = allBuildingSales;
//     } catch (e) {
//       isLoadingSales.value=false;
//       print("Error fetching building sales data: $e");
//     }
//   }

  var buildingSaleData = <String, dynamic>{}.obs; // Observable map for building sale data
  var isLoading = false.obs; // Observable loading state

// Method to fetch building sale details using documentId
  Future<void> fetchSingleBuildingSale(String documentId) async {
    isLoading.value = true; // Set loading to true
    try {
      final data = await _fetchSingleBuildingSaleFromFirestore(documentId);
      if (data != null) {
        buildingSaleData.value = data;
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
  Future<Map<String, dynamic>?> _fetchSingleBuildingSaleFromFirestore(
      String documentId) async {
    try {
      DocumentSnapshot doc =
      await fireStore.collection('buildingSale').doc(documentId).get();

      if (doc.exists) {
        Map<String, dynamic> buildingSaleData =
        doc.data() as Map<String, dynamic>;
        String? customerId = buildingSaleData["customerId"];
        String? buildingId = buildingSaleData["buildingId"];

        // Prepare a batch request for fetching customer and building data
        List<DocumentSnapshot> customerDocs = [];
        List<DocumentSnapshot> buildingDocs = [];

        if (customerId != null) {
          customerDocs.add(await fireStore.collection('customer').doc(customerId).get());
        }

        if (buildingId != null) {
          buildingDocs.add(await fireStore.collection('building').doc(buildingId).get());
        }

        Map<String, dynamic>? customerData;
        Map<String, dynamic>? buildingData;

        // Extract customer data
        if (customerDocs.isNotEmpty && customerDocs[0].exists) {
          customerData = customerDocs[0].data() as Map<String, dynamic>;
        }

        // Extract building data
        if (buildingDocs.isNotEmpty && buildingDocs[0].exists) {
          buildingData = buildingDocs[0].data() as Map<String, dynamic>;
        }

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
    String baseDueDate = installmentDateController.text; // Expecting format "YYYY-MM-DD"

    // Ensure the base date is not empty or invalid
    if (baseDueDate.isEmpty) {
      print("No base due date provided.");
      return;
    }

    // Parse the baseDueDate
    DateTime? baseDate = DateTime.tryParse(baseDueDate);
    if (baseDate == null) {
      print("Invalid base due date format.");
      return;
    }

    // Generate installment plan based on installment count
    for (int i = 0; i < installmentCount; i++) {
      // Correct month and year increment to avoid invalid months
      DateTime installmentDate = DateTime(
          baseDate.year + ((baseDate.month + i - 1) ~/ 12),  // Handles year rollover
          ((baseDate.month + i - 1) % 12) + 1,               // Handles month rollover
          baseDate.day
      );

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

  // void installmentNumberData() {
  //   // Clear previous installment plans if necessary
  //   installmentPlan.clear();
  //
  //   int installmentCount = int.tryParse(installmentCountController.text) ?? 0;
  //
  //   // Get the base due date from the controller
  //   String baseDueDate =
  //       installmentDateController.text; // Expecting format "YYYY-MM-DD"
  //
  //   // Ensure the base date is not empty or invalid
  //   if (baseDueDate.isEmpty) {
  //     print("No base due date provided.");
  //     return;
  //   }
  //
  //   // Generate installment plan based on installment count
  //   for (int i = 0; i < installmentCount; i++) {
  //     // Parse the baseDueDate
  //     DateTime? baseDate = DateTime.tryParse(baseDueDate);
  //     if (baseDate == null) {
  //       print("Invalid base due date format.");
  //       return;
  //     }
  //
  //     // Set the installment due date based on the base date
  //     DateTime installmentDate =
  //         DateTime(baseDate.year, baseDate.month + i, baseDate.day);
  //
  //     // Format the due date as "YYYY-MM-DD"
  //     String dueDate = installmentDate.toIso8601String().substring(0, 10);
  //
  //     // Fetch the amount dynamically from the controller
  //     double amount = double.tryParse(amountInstallmentController.text) ?? 0.0;
  //
  //     // Create the installment entry
  //     var installmentEntry = {
  //       "id": i + 1,
  //       "dueDate": dueDate,
  //       "amount": amount,
  //       "status": "Unpaid",
  //     };
  //
  //     // Add to the installment plan list
  //     installmentPlan.add(installmentEntry);
  //
  //     // Print the installment entry for debugging
  //     print("Installment Entry: $installmentEntry");
  //   }
  //
  //   // Print the entire installment plan after creation
  //   print("Complete Installment Plan: $installmentPlan");
  // }

// Date picker function to handle user input

  // await updateInstallmentPlanStatus('YOUR_DOCUMENT_ID', 2, 'completed');

  Future<void> updateInstallmentPlanStatus(
      String documentId,
      singleDocumentId,
      int installmentId,
      String newStatus,
      BuildContext context,
      dueAmount) async {
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
    String newStatus, BuildContext context,
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
        wrongSnackBar(context,title: "Error", "Document does not exist.");
      }
    } catch (e) {
      print("Failed to update building status: $e");
      wrongSnackBar(context,title: "Exception", "Failed to update building status: $e");
    }
  }

  Future<void> uploadImageAndCreateBuildingSale(String buildingId,
      String? imagePath, BuildContext context, grandTotal) async {
    appLoader(context, "Building Sale, please wait...");

    try {
      // Await the customer ID from the customer creation function
      String? customerId =
          await uploadImageAndCreateCustomer(imagePath, context);
      double totalCost = double.tryParse(grandTotal.toString()) ?? 0.0;
      double discountAmount = double.tryParse(buildingSaleController.discountAmountTotal.value) ?? 0.0;
      double finalAmount = totalCost - discountAmount;

      // Prepare the body for building sale
      // Prepare the body for building sale
      Map<String, dynamic> body = {
        "buildingId": buildingId,
        "customerId": customerId,
        "installmentCount": installmentCountController.text,
        "bookDownPayment": percentageAmount.value,
        "handoverDate": handoverDateController.text,
        "bookingPaymentPercent": paymentBookingPercentageCountController.text,
        "dueAmount": dueAmount.text,
        "totalCost": grandTotal ?? 0.0,
        "status": "Pending",
        "BookingDate": DateTime.now(),
        "discountType": selectedDiscountType,
        "discountFull": {
          "apply_Discount": totalDiscount.text.trim(),
          "apply_Discount_type": selectTotalAmountDiscountType.toString(),
          "discountAmount": discountTotalAmount.value,
          "totalDue": finalAmount.toStringAsFixed(2),
        },
        "discountDue": {
          "apply_Discount": dueAmountDiscountController.text.trim(),
          "apply_Discount_type": selectDueAmountDiscountType.toString(),
          "discountAmount": discountDueAmount.value,
          "totalDue": totalDueAmount.text,
        },
        "installmentPlan": installmentPlan,
      };

      print(body);

      // Save the building sale to Firestore
      DocumentReference docRef =
          await fireStore.collection('buildingSale').add(body);
      uploadBuildingStates(buildingId, "Book",context);
      createSaleReport(context,
          buildingId: buildingId,
          customerId: customerId,
          amount: percentageAmount.value,
          paymentType: "Booking");

      buildingController.fetchProjects();
      clearData();
      Navigator.pop(context);
      Navigator.pop(context);
      dashbordScreenController.dataIndex.value=4;
      // Navigator.push(context,
          // MaterialPageRoute(builder: (context) => BuildingSalesScreen()));
      // context.go("/buildingView");
      successSnackBar("Building Sale created successfully!");
    } catch (e, stackTrace) {
      Navigator.pop(context);
      wrongSnackBar(context,title: "Exception", "Failed to create building sale: $e");
      print("Error adding building sale: $e");
      print("StackTrace: $stackTrace");
    }
  }

  Future createSaleReport(BuildContext context,
      {buildingId, customerId, amount, paymentType}) async {
    // appLoader(context, "Creating Sale Report, please wait...");

    try {
      // Prepare customer data to be saved
      Map<String, dynamic> customerBody = {
        "buildingId": buildingId,
        "customerId": customerId,
        "DateTime": DateTime.now(),
        "Amount": amount,
        "paymentType": paymentType,
      };

      // Save the customer to Firestore
      DocumentReference docRef = await fireStore
          .collection('BookingSalePaymentReport')
          .add(customerBody);

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

        if(kIsWeb){
          imageUrl = await uploadImageToFirebaseForWeb(imagePath);

        }else{
          imageUrl = await uploadImageToFirebase(imagePath);

        }
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
        "DateTime": DateTime.now(),
      };

      // Save the customer to Firestore
      DocumentReference docRef =
          await fireStore.collection('customer').add(customerBody);

      customerController.fetchCustomer();
      // Navigator.pop(context);
      // successSnackBar("Customer created successfully!");

      // Return the created customer ID
      return docRef.id;
    } catch (e, stackTrace) {
      Navigator.pop(context);
      wrongSnackBar(context,title: "Exception", "Failed to create customer: $e");
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
  Future<String?> uploadImageToFirebaseForWeb(String imagePath) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Create a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference imageRef = storageRef.child('customer_images/$fileName.jpg');

      print("Starting image upload...");

      // Check if running on the web
      if (kIsWeb) {
        // For web, use a FileReader to read the file
        final reader = html.FileReader();
        final file = html.File([await html.window.fetch(imagePath).then((response) => response.blob())], imagePath);

        // Upload the file as a Blob
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) async {
          Uint8List bytes = reader.result as Uint8List;
          await imageRef.putData(bytes);
        });

        // Wait for the upload to complete
        // You might want to use Future.delayed or a similar method to ensure the upload is complete.
        await Future.delayed(const Duration(seconds: 2)); // Adjust duration as needed

      } else {
        // For mobile and desktop
        UploadTask uploadTask = imageRef.putFile(File(imagePath));

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          print('Upload progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
        });

        // Wait for the upload to complete
        TaskSnapshot snapshot = await uploadTask;
      }

      // Get the download URL of the uploaded image
      String imageUrl = await imageRef.getDownloadURL();
      print("Image uploaded successfully. URL: $imageUrl");
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

}
