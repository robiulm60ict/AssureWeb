import 'package:assure_apps/configs/app_constants.dart';
import 'package:assure_apps/test.dart';
import 'package:assure_apps/view/building_sale/building_sale_setup/building_sale_setup.dart';
import 'package:assure_apps/view/building_sale/sale_view/sale_details_installment_view.dart';
import 'package:assure_apps/view/entry_point.dart';
import 'package:assure_apps/view/sales_report_view_list/sale_report_view.dart';
import 'package:assure_apps/view/sign_in_page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_strategy/url_strategy.dart';

import 'configs/app_theme.dart';
import 'configs/database/login.dart';
import 'controllers/building_controller/building_controller.dart';
import 'controllers/building_sale_controller/building_sale_controller.dart';
import 'firebase_options.dart';
import 'model/buliding_model.dart';
import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive for Flutter
  await LocalDB.init(); // Open Hive box for local storage

  // Initialize Hive for mobile/desktop
  if (!kIsWeb) {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  } else {
    Hive.init('web_storage'); // For web, provide a placeholder path
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();

  // Register controllers before running the app
  Get.put(BuildingController()); // Register BuildingController
  Get.put(BuildingSaleController()); // Register BuildingSaleController

  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),

        GetPage(name: '/entryPoint', page: () => const EntryPoint()),
        GetPage(name: '/signInPage', page: () => SignInPage()),

        // Route for building sale details
        GetPage(
          name: '/buildingSaleDetail',
          page: () {
            return FutureBuilder(
              future: Get.find<BuildingSaleController>().loadBuildingSaleId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                } else {
                  final buildingId = snapshot.data;
                  if (buildingId == null || buildingId.isEmpty) {
                    return const Scaffold(
                      body: Center(
                        child: Text('No Building available'),
                      ),
                    );
                  }
                  return BuildingSaleDetailScreen(documentId: buildingId);
                }
              },
            );
          },
          binding: BindingsBuilder(() {
            Get.lazyPut<BuildingSaleController>(() => BuildingSaleController());
          }),
        ),

        // Route for building sale setup
        GetPage(
          name: '/buildingSaleSetup',
          page: () {
            final buildingController = Get.find<BuildingController>();
            return FutureBuilder(
              future: buildingController.loadBuildingModelId(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(), // Show loading indicator
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Error: ${snapshot.error}'), // Display error message
                    ),
                  );
                } else {
                  final buildingId = snapshot.data; // Loaded ID from storage
                  if (buildingId == null || buildingId.isEmpty) {
                    return const Scaffold(
                      body: Center(
                        child: Text('No Building available'), // Handle missing ID
                      ),
                    );
                  }

                  return BuildingSaleSetup(id: buildingId); // Pass the model to the widget
                }
              },
            );
          },
        ),
      ],
    );
  }
}
