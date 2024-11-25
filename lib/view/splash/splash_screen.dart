import 'package:assure_apps/configs/app_image.dart';
import 'package:assure_apps/configs/ghaps.dart';
import 'package:assure_apps/configs/routes.dart';
import 'package:assure_apps/view/entry_point.dart';
import 'package:assure_apps/view/sign_in_page/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/app_colors.dart';
import '../../configs/app_constants.dart';
import '../../configs/database/login.dart';
import '../../responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose(); // Dispose of the AnimationController
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animationController.forward();

    // Trigger visibility event after 500ms
    Future.delayed(const Duration(seconds: 2), ()  {
      pageRoute();

    });
  }

  pageRoute()async{
    final myData = await LocalDB.getLoginInfo();
    if (myData?['email'] == "") {
      // AppRoutes.push(context, page: SignInPage());
      Navigator.pushNamed(context, '/signInPage');

      //   context.go('/sign-in');
    } else {
      Navigator.pushNamed(context, '/entryPoint');

      print("info.................$myData");
      print("info.................${myData?['email']}");
      // AppRoutes.push(context, page: EntryPoint());

      //   context.go('/entry-point');
    }

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

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }
}
