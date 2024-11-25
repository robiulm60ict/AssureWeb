import 'package:assure_apps/configs/app_constants.dart';
import 'package:assure_apps/test.dart';
import 'package:assure_apps/view/building_sale/building_sale_setup/building_sale_setup.dart';
import 'package:assure_apps/view/building_sale/sale_view/sale_details_installment_view.dart';
import 'package:assure_apps/view/entry_point.dart';
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
import 'firebase_options.dart';
import 'model/buliding_model.dart';
import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Call Hive initialization for Flutter
  await LocalDB.init(); // Open the Hive box here

  // Initialize Hive
  if (!kIsWeb) {
    // Only initialize Hive on mobile/desktop
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
  } else {
    // For web, we can use a temporary path or skip Hive initialization if not needed
    Hive.init('web_storage'); // Provide a placeholder path for web
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();

  // Put the BuildingController into memory before running the app
  Get.put(BuildingController());

  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/signInPage', page: () => SignInPage()),
        GetPage(name: '/entryPoint', page: () => const EntryPoint()),
        // You can also use arguments in GetX routes
        GetPage(
          name: '/buildingSaleDetailScreen',
          page: () {
            // Arguments can be passed directly using Get arguments
            final args = Get.arguments as Map<String, dynamic>;
            return BuildingSaleDetailScreen(
              documentId: args['documentId'],
              buildingSales: args['buildingSales'],
            );
          },
        ),
        // GetPage(
        //   name: '/buildingSaleSetup',
        //   page: () {
        //     final args = Get.arguments as BuildingModel?;
        //     print("argsSsssssssss$args");
        //
        //     return BuildingSaleSetup(model: args); // Pass the non-null model
        //   },
        // ),

        GetPage(
          name: '/buildingSaleSetup',
          page: () {
            final buildingController = Get.find<BuildingController>();

            return FutureBuilder(
              future: buildingController.loadBuildingModel(), // Make sure this is awaited
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Center(child: CircularProgressIndicator())); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
                } else {
                  final buildingModel = buildingController.getBuildingModel();
                  return buildingModel == null
                      ? Scaffold(body: Center(child: Text('No data available')))
                      : BuildingSaleSetup(model: buildingModel);
                }
              },
            );
          },
        )


      ],
    );

  }
}
