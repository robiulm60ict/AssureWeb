import 'package:assure_apps/view/entry_point.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../configs/database/login.dart';
import '../../widgets/app_loader.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, (user) {
      // Ensure context is available before navigating
      if (Get.context != null) {
        _setInitialScreen(user);
      }
    });
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      GoRouter.of(Get.context!).go('/login'); // Redirect to login
    } else {
      GoRouter.of(Get.context!).go('/entry-point'); // Redirect to entry point
    }
  }

  void register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password).then((v) async{


        GoRouter.of(Get.context!).go('/entry-point'); // Redirect after registration
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void login(String email, String password,BuildContext context) async {
    appLoader(context, "Sign In , please wait...");

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password).then((v) async{
        await LocalDB.postLoginInfo(
          email: email,
          password: password,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EntryPoint()),
        );
        // Get.offAll(EntryPoint());
        // Navigator.push(context, Matat)



      });
    } catch (e) {
      Navigator.pop(context);
      Get.snackbar("Login Error", e.toString());
    }
  }

  void logout() async {
    await auth.signOut().then((_) {
      GoRouter.of(Get.context!).go('/login'); // Redirect to login after logout
    });
  }
}
