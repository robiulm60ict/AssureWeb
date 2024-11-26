import 'dart:io';

import 'package:assure_apps/configs/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import '../../model/buliding_model.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/snackbar.dart';
import 'dart:html' as html; // Import this for web compatibility

class BuildingController extends GetxController {
  var projects = <BuildingModel>[].obs;
  var isLoading=false.obs;
  var isSingleLoading=false.obs;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyUpdate = GlobalKey<FormState>();

  final TextEditingController prospectNameController = TextEditingController();
  final TextEditingController persqftPriceController = TextEditingController();
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
  final storage = GetStorage();


  void saveBuildingModelId(String id) {
    // Save only the ID to storage
    storage.write('buildingModelId', id);
    print("BuildingModel ID saved: $id");
  }
  Future<String?> loadBuildingModelId() async {
    return storage.read<String>('buildingModelId');
  }




  void fetchProjects() async {
    try {
      isLoading.value = true; // Start loading
      final snapshot = await fireStore.collection('building').orderBy('createDateTime',descending: true).get();

      // Map the documents to BuildingModel instances
      projects.value = snapshot.docs
          .map((doc) => BuildingModel.fromFirestore(doc.data(), doc.id))
          .toList();

      // Optionally, you can print the fetched projects for debugging

    } catch (e,k) {
      // Handle any errors that occur during fetching
      if (kDebugMode) {
        print("Error fetching projects: $e");
        print("Error fetching projects: $k");
      }
      // Optionally, you can show an error message to the user
    } finally {
      isLoading.value = false; // Stop loading
    }
  }
  Future<BuildingModel?> fetchSingleProjects(String buildingId) async {
    try {
      isSingleLoading.value = true; // Start loading
      final snapshot = await fireStore
          .collection('building')
          .doc(buildingId)
          .get(); // Fetch specific document

      if (snapshot.exists) {
        // Return the BuildingModel if the document exists
        return BuildingModel.fromFirestore(snapshot.data()!, snapshot.id);
      } else {
        if (kDebugMode) {
          print("No project found for ID: $buildingId");
        }
        return null; // Return null if the document doesn't exist
      }
    } catch (e, stacktrace) {
      // Handle any errors that occur during fetching
      if (kDebugMode) {
        print("Error fetching single project: $e");
        print("Stacktrace: $stacktrace");
      }
      return null; // Return null if an error occurs
    } finally {
      isSingleLoading.value = false; // Stop loading
    }
  }


  //
  Future<void> uploadImageAndCreateProjectForWeb(BuildingModel project, String? imagePath, BuildContext context) async {
    appLoader(context, "Building, please wait...");
    print(project.toFirestore());

    try {
      // Add the current timestamp for createDateTime
      project.createDateTime = DateTime.now();

      // Upload image to Firebase Storage only if imagePath is provided
      String? imageUrl;
      if (imagePath != null && imagePath.isNotEmpty) {
        try {
          imageUrl = await uploadImageToFirebaseForWeb(imagePath);
          // If the image was uploaded successfully, set the image URL in the project object
          project.image = imageUrl;
        } catch (uploadError) {
          print("Error uploading image: $uploadError");
          wrongSnackBar(context,title: "Upload Error", "Failed to upload image: $uploadError");
          // Optionally, you can decide to proceed without the image
          // project.image = null; // Uncomment if you want to set it to null
        }
      }

      // Save the project to Firestore
      DocumentReference docRef = await fireStore.collection('building').add(project.toFirestore());
      project.id = docRef.id;
      projects.add(project);

      clearData();
      Navigator.pop(context);
      dashbordScreenController.dataIndex.value = 2;
      successSnackBar("Building created successfully!");

    } catch (e, stackTrace) {
      Navigator.pop(context);
      wrongSnackBar(context,title: "Exception", "Failed to create building: $e");
      print("Error adding project: $e");
      print("StackTrace: $stackTrace");
    }
  }


  Future<String?> uploadImageToFirebaseForWeb(String imagePath) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();

      // Create a unique file name for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference imageRef = storageRef.child('building_images/$fileName.jpg');

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
      wrongSnackBar(context,title: "Exception", "Failed to create building: $e");
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
      wrongSnackBar(context,title: "Exception", "Failed to update building: $e");
    }
  }

  Future<void> updateProjectForWeb(BuildingModel project, String? newImagePath, BuildContext context) async {
    try {
      appLoader(context, "Updating Building, please wait...");

      // Set the updateDateTime to now
      project.updateDateTime = DateTime.now();

      // If a new image is provided, upload it and update the project image URL
      if (newImagePath != null && newImagePath.isNotEmpty) {
        String? imageUrl = await uploadImageToFirebaseForWeb(newImagePath);
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
      wrongSnackBar(context,title: "Exception", "Failed to update building: $e");
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
