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

class BuildingController extends GetxController {
  var projects = <BuildingModel>[].obs;
  var isLoading=false.obs;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();

  final TextEditingController prospectNameController = TextEditingController();
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectAddressController = TextEditingController();
  final TextEditingController floorNoController = TextEditingController();
  final TextEditingController appointmentSizeController = TextEditingController();
  final TextEditingController perSftPriceController = TextEditingController();
  final TextEditingController totalUnitPriceController = TextEditingController();
  final TextEditingController carParkingController = TextEditingController();
  final TextEditingController unitCostController = TextEditingController();
  final TextEditingController totalCostController = TextEditingController();

  var imageUrl="";

  clearData(){
    prospectNameController.clear();
    perSftPriceController.clear();
    projectAddressController.clear();
    projectNameController.clear();
    totalCostController.clear();
    unitCostController.clear();
    totalUnitPriceController.clear();
    carParkingController.clear();
    appointmentSizeController.clear();
    floorNoController.clear();
    imageController.resizedImagePath.value="";
    imageController.originalImagePath.value="";
    imageUrl="";

  }
  @override
  void onInit() {
    super.onInit();
    appointmentSizeController.addListener(updateTotalUnitPrice);
    perSftPriceController.addListener(updateTotalUnitPrice);
    unitCostController.addListener(updateTotalCost);
    carParkingController.addListener(updateTotalCost);
    fetchProjects(); // Fetch projects on initialization
  }

  @override
  void onClose() {
    // Dispose of the controllers
    appointmentSizeController.dispose();
    perSftPriceController.dispose();
    totalUnitPriceController.dispose();
    unitCostController.dispose();
    carParkingController.dispose();
    totalCostController.dispose();
    super.onClose();
  }
  void updateTotalUnitPrice() {
    final appointmentSize = double.tryParse(appointmentSizeController.text) ?? 0;
    final perSftPrice = double.tryParse(perSftPriceController.text) ?? 0;

    final totalUnitPrice = appointmentSize * perSftPrice;
    totalUnitPriceController.text = totalUnitPrice.toStringAsFixed(2);

    updateTotalCost(); // Update total cost whenever total unit price changes
  }

  void updateTotalCost() {
    final totalUnitPrice = double.tryParse(totalUnitPriceController.text) ?? 0;
    final unitCost = double.tryParse(unitCostController.text) ?? 0;
    final carParking = double.tryParse(carParkingController.text) ?? 0;

    final totalCost = totalUnitPrice + unitCost + carParking;
    totalCostController.text = totalCost.toStringAsFixed(2); // Format to 2 decimal places
  }
  void fetchProjects() async {
    try {
      isLoading.value = true; // Start loading
      final snapshot = await fireStore.collection('building').get();

      // Map the documents to BuildingModel instances
      projects.value = snapshot.docs
          .map((doc) => BuildingModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Optionally, you can print the fetched projects for debugging

    } catch (e) {
      // Handle any errors that occur during fetching
      if (kDebugMode) {
        print("Error fetching projects: $e");
      }
      // Optionally, you can show an error message to the user
    } finally {
      isLoading.value = false; // Stop loading
    }
  }


  Future<void> uploadImageAndCreateProject(BuildingModel project, String? imagePath, BuildContext context) async {
    appLoader(context, "Building, please wait...");
    try {
      // Add the current timestamp for createDateTime
      project.createDateTime = DateTime.now();

      // Upload image to Firebase Storage only if imagePath is provided
      String? imageUrl;
      if (imagePath != null && imagePath.isNotEmpty) {
        imageUrl = await uploadImageToFirebase(imagePath);
      }

      // If the image was uploaded, set the image URL in the project object
      if (imageUrl != null) {
        project.image = imageUrl;
      }

      // Save the project to Firestore
      DocumentReference docRef = await fireStore.collection('building').add(project.toFirestore());
      project.id = docRef.id;
      projects.add(project);
      imageController.resizedImagePath.value="";
      clearData();
      Navigator.pop(context);
      dashbordScreenController.dataIndex.value=2;
     // AppRoutes.push(context, page: const BuildingView());
      // context.go("/buildingView");
      // successSnackBar("Building created successfully!");

    } catch (e, stackTrace) {
      Navigator.pop(context);
      wrongSnackBar(title: "Exception", "Failed to create building: $e");
    }
  }

  Future<String?> uploadImageToFirebase(String imagePath) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Create a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference imageRef = storageRef.child('building_images/$fileName.jpg');


      // Upload the image file to Firebase Storage
      UploadTask uploadTask = imageRef.putFile(File(imagePath));

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      });

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }



  // void createProject(BuildingModel project, BuildContext context) async {
  //   appLoader(context, "Building, please wait...");
  //
  //   try {
  //     // Add the current timestamp for createDateTime
  //     project.createDateTime = DateTime.now();
  //
  //     DocumentReference docRef = await fireStore.collection('projects').add(project.toFirestore());
  //     project.id = docRef.id;
  //     projects.add(project);
  //
  //     Navigator.pop(context);
  //     context.go("/buildingView");
  //     successSnackBar("Building created successfully!");
  //
  //   } catch (e, stackTrace) {
  //     Navigator.pop(context);
  //     wrongSnackBar(title: "Exception","Failed to create building: $e");
  //     print("Error adding project: $e");
  //     print("StackTrace: $stackTrace");
  //   }
  // }

  // void updateProject(BuildingModel project, BuildContext context) async {
  //   try {
  //     appLoader(context, "Updating Building, please wait...");
  //
  //     // Set the updateDateTime to now
  //     project.updateDateTime = DateTime.now();
  //
  //     await fireStore.collection('projects').doc(project.id).update(project.toFirestore());
  //     Navigator.pop(context);
  //     context.go('/buildingView');
  //     fetchProjects(); // Refresh the project list
  //
  //   } catch (e) {
  //     Navigator.pop(context);
  //     wrongSnackBar(title: "Exception",  "Failed to update building: $e");
  //     print("Error updating project: $e");
  //   }
  // }

  Future<void> updateProject(BuildingModel project, String? newImagePath, BuildContext context) async {
    try {
      appLoader(context, "Updating Building, please wait...");

      // Set the updateDateTime to now
      project.updateDateTime = DateTime.now();

      // If a new image is provided, upload it and update the project image URL
      if (newImagePath != null && newImagePath.isNotEmpty) {
        String? imageUrl = await uploadImageToFirebase(newImagePath);
        if (imageUrl != null) {
          project.image = imageUrl; // Update the project's image URL
        }
      }

      // Update the project document in Firestore with the new data
      await fireStore.collection('building').doc(project.id).update(project.toFirestore());
      Navigator.pop(context);
      Navigator.pop(context);
      imageController.resizedImagePath.value="";

      // context.go('/buildingView');
      fetchProjects(); // Refresh the project list
      dashbordScreenController.dataIndex.value=2;

      // AppRoutes.pushReplacement(context, page: const BuildingView());

    } catch (e) {
      Navigator.pop(context);
      wrongSnackBar(title: "Exception", "Failed to update building: $e");
    }
  }



  void deleteProject(String id, BuildContext context) async {
    try {
      appLoader(context, "Deleting Building, please wait...");
      await fireStore.collection('building').doc(id).delete();
      Navigator.pop(context); // Close loader
      projects.removeWhere((project) => project.id == id); // Remove from local list
    } catch (e) {
      Navigator.pop(context); // Close loader if there's an error
      // _showErrorDialog(context, "Failed to delete project: $e");
    }
  }

}
