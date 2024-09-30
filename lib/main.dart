import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'configs/app_theme.dart';
import 'configs/routes.dart';
import 'firebase_options.dart';
import 'view/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(context),
      home: const SplashScreen(),
    );
  }
}
