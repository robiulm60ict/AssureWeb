import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../configs/app_colors.dart';
import '../configs/ghaps.dart';
import '../responsive.dart';



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
            // if (Responsive.isMobile(context))
            //   IconButton(
            //     onPressed: () {},
            //     icon: const Badge(
            //       isLabelVisible: false,
            //       child: HugeIcon(
            //         icon: HugeIcons.strokeRoundedSearch01,
            //         color: Colors.black,
            //         size: 24.0,
            //       )
            //     ),
            //   ),
            // if (!Responsive.isMobile(context))
            //   Expanded(
            //     flex: 1,
            //     child: TextFormField(
            //       // style: Theme.of(context).textTheme.labelLarge,
            //       decoration: InputDecoration(
            //         hintText: "Search...",
            //         prefixIcon: const Padding(
            //           padding: EdgeInsets.only(
            //               left: AppDefaults.padding,
            //               right: AppDefaults.padding / 2),
            //           child:HugeIcon(
            //             icon: HugeIcons.strokeRoundedSearch01,
            //             color: Colors.black,
            //             size: 24.0,
            //           )
            //         ),
            //         filled: true,
            //         fillColor: Theme.of(context).scaffoldBackgroundColor,
            //         border: AppDefaults.outlineInputBorder,
            //         focusedBorder: AppDefaults.focusedOutlineInputBorder,
            //       ),
            //     ),
            //   ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // if (!Responsive.isMobile(context))
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: const Badge(
                  //       isLabelVisible: true,
                  //       child:
                  //       HugeIcon(
                  //         icon: HugeIcons.strokeRoundedMessageNotification02,
                  //         color: Colors.black,
                  //         size: 24.0,
                  //       )
                  //     ),
                  //   ),
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
                      onPressed: () {},
                      icon: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn.create.vista.com/api/media/small/339818716/stock-photo-doubtful-hispanic-man-looking-with-disbelief-expression"),
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
}
