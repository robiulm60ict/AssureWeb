// lib/configs/pdf/pdf_windows.dart

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
