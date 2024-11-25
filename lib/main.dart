import 'package:assure_apps/configs/app_constants.dart';
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

  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(context),
      // home: const SplashScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/signInPage': (context) =>  SignInPage(),
        '/entryPoint': (context) =>  const EntryPoint(),
        '/buildingSaleDetailScreen': (context) {
          // Extract the arguments from the ModalRoute
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

          // Ensure 'documentId' and 'buildingSales' are correctly extracted from the arguments
          final documentId = args['documentId'] as String;
          final buildingSales = args['buildingSales'] as Map<String, dynamic>;

          // Return the BuildingSaleDetailScreen with the extracted arguments
          return BuildingSaleDetailScreen(
            documentId: documentId,
            buildingSales: buildingSales,
          );
        },
        '/buildingSaleSetup': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as BuildingModel?;
          return BuildingSaleSetup(model: args); // Pass the nullable model
        },

      },
    );
  }
}
