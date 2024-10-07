// ignore_for_file: avoid_print

import 'dart:async' show Completer;
import 'dart:math' show min;
import 'dart:typed_data' show Uint8List, BytesBuilder;

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:web/web.dart' as web;
import 'package:get/get.dart';

class TestView extends StatefulWidget {
  const TestView({Key? key}) : super(key: key);

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  late DropzoneViewController controller1;
  final ImageController imageController = Get.put(ImageController());
  String message1 = 'Drop something here';
  bool highlighted1 = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text('Dropzone Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
               await controller1.pickFiles(mime: ['image/jpeg', 'image/png']);
              },
              child: Container(
                color: highlighted1 ? Colors.red : Colors.transparent,
                child: Stack(
                  children: [
                    buildZone1(context),
                    Center(child: Text(message1)),
                  ],
                ),
              ),
            ),
          ),
          // Display the uploaded image using GridView
          Expanded(
            child: Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: imageController.images.length,
              itemBuilder: (context, index) {
                return Image.memory(imageController.images[index]);
              },
            )),
          ),
        ],
      ),
    ),
  );

  Widget buildZone1(BuildContext context) => Builder(
    builder: (context) => DropzoneView(
      operation: DragOperation.copy,
      cursor: CursorType.grab,
      onCreated: (ctrl) => controller1 = ctrl,
      onLoaded: () => print('Zone 1 loaded'),
      onError: (ev) => print('Zone 1 error: $ev'),
      onHover: () {
        setState(() => highlighted1 = true);
        print('Zone 1 hovered');
      },
      onLeave: () {
        setState(() => highlighted1 = false);
        print('Zone 1 left');
      },
      onDrop: (ev) async {
        if (ev is web.File) {
          print('Zone 1 drop: ${ev.name}');
          setState(() {
            message1 = '${ev.name} dropped';
            highlighted1 = false;
          });
          final bytes = await controller1.getFileData(ev);
          print('Read bytes with length ${bytes.length}');
          print(bytes.sublist(0, min(bytes.length, 20)));

          // Add dropped image to GetX controller
          imageController.addImage(bytes);
        } else if (ev is String) {
          print('Zone 1 drop: $ev');
          setState(() {
            message1 = 'Text dropped';
            highlighted1 = false;
          });
          print(ev.substring(0, min(ev.length, 20)));
        } else {
          print('Zone 1 unknown type: ${ev.runtimeType}');
        }
      },
      onDropInvalid: (ev) => print('Zone 1 invalid MIME: $ev'),
      onDropMultiple: (ev) async {
        print('Zone 1 drop multiple: $ev');
      },
    ),
  );

  Future<Uint8List> collectBytes(Stream<List<int>> source) {
    var bytes = BytesBuilder(copy: false);
    var completer = Completer<Uint8List>.sync();
    source.listen(
      bytes.add,
      onError: completer.completeError,
      onDone: () => completer.complete(bytes.takeBytes()),
      cancelOnError: true,
    );
    return completer.future;
  }
}

class ImageController extends GetxController {
  var images = <Uint8List>[].obs;

  void addImage(Uint8List image) {
    // Clear previous images before adding a new one
    images.clear();
    images.add(image);
  }
}
