import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class GetImageController extends GetxController {
  RxBool isLoading = true.obs;


  var resizedImagePath = ''.obs;
  var originalImagePath = ''.obs;
  var imagePaths = <String>[].obs;

  final ImagePicker _picker = ImagePicker();



  Future<void> pickImage({required bool fromGallery}) async {
    try {
      originalImagePath.value = '';
      resizedImagePath.value = '';

      final XFile? image = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      );

      print("Picked image path: ${image?.path}");
      if (image != null) {
        originalImagePath.value = image.path;
        print("Original Image Path: ${originalImagePath.value}");

        // Check if the platform is supported for compression
        if (kIsWeb || Platform.isWindows) {
          print("Image compression is not supported on this platform.");
          resizedImagePath.value = originalImagePath.value; // Use the original image path for unsupported platforms
        } else {
          Directory documentsDirectory = await getApplicationDocumentsDirectory();
          String targetDirectoryPath = documentsDirectory.path;

          Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
            originalImagePath.value,
            minWidth: 800,
            minHeight: 600,
            quality: 85,
          );

          if (compressedImage != null) {
            resizedImagePath.value = '$targetDirectoryPath/resized_image.jpg';
            File resizedImageFile = File(resizedImagePath.value);
            await resizedImageFile.writeAsBytes(compressedImage);

            print("Resized Image Path: ${resizedImagePath.value}");
          } else {
            print("Image compression failed.");
          }
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> pickImageMulti({required bool fromGallery}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      );

      if (image != null) {
        String originalImagePath = image.path;

        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String targetDirectoryPath = documentsDirectory.path;

        Uint8List? compressedImage =
            await FlutterImageCompress.compressWithFile(
          originalImagePath,
          minWidth: 800,
          minHeight: 600,
          quality: 85,
        );

        if (compressedImage != null) {
          String resizedImagePath =
              '$targetDirectoryPath/resized_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
          File resizedImageFile = File(resizedImagePath);
          await resizedImageFile.writeAsBytes(compressedImage);

          imagePaths.add(resizedImagePath);
        }
      } else {
        Get.snackbar('Error', fromGallery ? "Select an Image" : "Take a Photo");
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

}