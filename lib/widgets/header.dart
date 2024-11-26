import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../configs/app_colors.dart';
import '../configs/database/login.dart';
import '../configs/ghaps.dart';
import '../configs/routes.dart';
import '../responsive.dart';
import '../view/sign_in_page/sign_in_page.dart';
import 'app_alert_dialog.dart';



class Header extends StatelessWidget {
  const Header({super.key, required this.drawerKey});

  final GlobalKey<ScaffoldState> drawerKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(
      //     horizontal: AppDefaults.padding, vertical: AppDefaults.padding),
      color: AppColors.bgSecondayLight,
      child: SafeArea(
        // bottom: false,
        child: Row(
          children: [
            if (Responsive.isMobile(context))
              IconButton(
                onPressed: () {
                  drawerKey.currentState!.openDrawer();
                },
                icon: const Badge(
                    isLabelVisible: false,
                    child:HugeIcon(
                      icon: HugeIcons.strokeRoundedMenu09,
                      color: Colors.black,
                      size: 24.0,
                    )
                ),
              ),

            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  if (!Responsive.isMobile(context)) gapW16,
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {},
                      icon: const Badge(
                          isLabelVisible: true,
                          child:HugeIcon(
                            icon: HugeIcons.strokeRoundedNotificationBlock02,
                            color: Colors.black,
                            size: 24.0,
                          )
                      ),
                    ),
                  if (!Responsive.isMobile(context)) gapW16,
                  if (!Responsive.isMobile(context))
                    IconButton(
                      onPressed: () {
                        showEmailLogoutDialog(context);
                      },
                      icon: const CircleAvatar(
                        radius: 35,
                       
                        child: Icon(Icons.person,size: 30,),
                      ),
                    ),

                  gapW16,

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEmailLogoutDialog(BuildContext context) async {
    // Fetch login information before showing the dialog
    Map<String, String>? loginInfo = await LocalDB.getLoginInfo();
    String? email = loginInfo?['email'] != "" && loginInfo!.isNotEmpty ? loginInfo[0] : 'No email found';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text('Account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text(
                'Email: ${loginInfo?['email']??"a"}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: InkWell(
                  onTap: () {
                    appAlertDialog(context, "Are you sure you want to logout?",
                        title: "Logout",
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the confirmation dialog
                            },
                            child: const Text("Dismiss"),
                          ),
                          TextButton(
                            onPressed: () {
                              LocalDB.delLoginInfo();
                              Get.toNamed("/signInPage");
                              // AppRoutes.pushAndRemoveUntil(context, page: SignInPage());
                            },
                            child: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ]);
                  },
                  child: const Row(
                    children: [
                      HugeIcon(
                        icon: HugeIcons.strokeRoundedLogout01,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      SizedBox(width: 16), // Using SizedBox for gap instead of gapW16
                      Text(
                        "LogOut",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

}
