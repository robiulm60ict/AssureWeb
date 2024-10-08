import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_constants.dart';
import '../../configs/app_image.dart';
import '../../configs/ghaps.dart';
import '../../configs/routes.dart';
import '../../responsive.dart';




class UpdateSplashScreen extends StatefulWidget {
  const UpdateSplashScreen({super.key});

  @override
  UpdateScreenState createState() => UpdateScreenState();
}

class UpdateScreenState extends State<UpdateSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  String? token, email, password;
  bool _visible = false;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }




  showDialog() async {
    await Future.delayed(const Duration(milliseconds: 50), () async {
      return await showAdaptiveDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Confirmation'),
              content: const Text('You can now update ${AppConstants.appName}'),
              actions: [
                TextButton(
                    onPressed: () {
                     InAppUpdate.performImmediateUpdate();
                    },
                    child: const Text('Update')
                ),
                TextButton(
                    onPressed: () {
                      AppRoutes.pop(context);
                    },
                    child: const Text('Maybe Later')
                ),
              ],
            );
          }
      );
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _visible = !_visible;
      });
    });
    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation.addListener(() => setState(() {}));
    animationController.forward();
    showDialog();
  }

  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri(
      scheme: 'https',
      host: 'www.m360ict.com',
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(color: AppColors.white),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: TextButton(
                      onPressed: () => _launchInBrowser(toLaunch),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Developed by ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "M360 ICT",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.indigoAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 1,
                    child: Lottie.asset(
                      AppImage.splashLottie,
                    ),
                  ),

                  gapH24,

                  AnimatedOpacity(
                    opacity: 0.5,
                    // opacity: isVisible ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 500),
                    child: Hero(
                      tag: 2,
                      child: Text(
                        AppConstants.appName,
                        style: GoogleFonts.lobster().copyWith(
                          fontSize:  Responsive.isMobile(context)?20:40,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));

  }
}