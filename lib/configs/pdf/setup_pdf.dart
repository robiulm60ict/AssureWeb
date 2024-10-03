

import 'dart:io' show Directory, File;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  Directory tempDir = await getTemporaryDirectory();
  String filePath = '${tempDir.path}/$fileName.pdf';

  try {
    // Create the PDF file and write the bytes to it.
    File tempFile = File(filePath);
    await tempFile.writeAsBytes(bytes, flush: true);
    print('File created: $filePath');

    // Open the PDF file with its associated app.
    final result = await OpenFile.open(filePath);

    print('File open result: ${result.message}');
    } catch (e) {
    print('Error: $e');
  }
}

// Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
//   if (kIsWeb) {
//     // Web implementation
//     final blob = html.Blob([Uint8List.fromList(bytes)], 'application/pdf');
//     final url = html.Url.createObjectUrlFromBlob(blob);
//
//     // Create an anchor element to download the file
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute('download', '$fileName.pdf')
//       ..click();
//
//     // Release the object URL after usage
//     html.Url.revokeObjectUrl(url);
//
//     print('File created and download started: $fileName.pdf');
//   } else {
//     // Mobile or desktop implementation (Windows)
//     Directory? tempDir = await getTemporaryDirectory(); // Use getTemporaryDirectory for cross-platform compatibility
//
//     if (tempDir == null) {
//       // Handle error: temporary storage directory not available
//       print('Temporary storage directory not available.');
//       return;
//     }
//
//     // Define the file path for the PDF file.
//     String filePath = '${tempDir.path}/$fileName.pdf';
//
//     try {
//       // Create the PDF file and write the bytes to it.
//       File tempFile = File(filePath);
//       await tempFile.writeAsBytes(bytes, flush: true);
//       print('File created: $filePath');
//
//       // Open the PDF file with its associated app.
//       final result = await OpenFile.open(filePath);
//
//       // Check if result is not null and handle success/failure
//       if (result != null) {
//         print('File open result: ${result.message}');
//       } else {
//         print('Unknown error occurred while opening the file.');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }
