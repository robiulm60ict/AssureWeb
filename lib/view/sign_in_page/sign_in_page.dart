import 'package:assure_apps/configs/app_image.dart';
import 'package:assure_apps/controllers/building_controller/building_controller.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_constants.dart';
import '../../configs/defaults.dart';
import '../../configs/ghaps.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false; // Password visibility toggle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDefaults.padding * 1.5,
                      ),
                      child: Center(
                        child: Image.asset(
                          AppImage.building,
                          height: MediaQuery.of(context).size.height * 0.20,
                        ),
                      ),
                    ),
                    Text(
                      'Sign In',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    gapH24,

                    const Divider(),
                    gapH24,

                    Text(
                      'Enter your email address & password',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    gapH16,

                    /// EMAIL TEXT FIELD
                    TextFormField(
                      controller: authController.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide:
                                BorderSide(color: AppColors.error, width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 0.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide: BorderSide(
                                color: AppColors.focusColor(context),
                                width: 0.5)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide: const BorderSide(
                                color: AppColors.error, width: 0.5)),
                        prefixIcon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedMail02,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        hintText: 'Your email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    gapH16,

                    /// PASSWORD TEXT FIELD
                    TextFormField(
                      controller: authController.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      obscureText: !_isPasswordVisible,
                      // Toggles visibility
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide: const BorderSide(
                                color: AppColors.error, width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 0.5)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide: BorderSide(
                                color: AppColors.focusColor(context),
                                width: 0.5)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSizes.bodyPadding - 5),
                            borderSide: const BorderSide(
                                color: AppColors.error, width: 0.5)),
                        prefixIcon: const HugeIcon(
                          icon: HugeIcons.strokeRoundedSquareLock02,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    gapH16,

                    /// SIGN IN BUTTON
                    SizedBox(
                      width: 320,
                      child: MaterialButton(
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          color: AppColors.primary,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              authController.login(
                                  authController.emailController.text,
                                  authController.passwordController.text,
                                  context);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                    gapH24,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
