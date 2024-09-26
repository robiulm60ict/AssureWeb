import 'package:assure_apps/configs/app_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../configs/app_constants.dart';
import '../../configs/defaults.dart';
import '../../configs/ghaps.dart';

class SignInPage extends StatelessWidget {
   SignInPage({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                          // color: Colors.transparent,
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

                      decoration: const InputDecoration(
                        prefixIcon: HugeIcon(
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

                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: HugeIcon(
                          icon: HugeIcons.strokeRoundedSquareLock02,
                          color: Colors.black,
                          size: 24.0,
                        ),
                        hintText: 'Password',
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
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            authController.login(
                                authController.emailController.text,
                                authController.passwordController.text,context);
                          }
                          //
                        },
                        child: const Text('Sign in'),
                      ),
                    ),
                    gapH24,

                    // /// FOOTER TEXT
                    // Text(
                    //   'This site is protected by reCAPTCHA and the Google Privacy Policy.',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // gapH24,

                    /// SIGNUP TEXT
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
