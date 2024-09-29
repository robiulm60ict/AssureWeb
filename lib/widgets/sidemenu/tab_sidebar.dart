
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../configs/app_constants.dart';
import '../../configs/app_image.dart';
import '../../configs/defaults.dart';
import '../../configs/ghaps.dart';
import 'icon_tile.dart';
import 'menu_tile.dart';

class TabSidebar extends StatelessWidget {
  const TabSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDefaults.padding,
                vertical: AppDefaults.padding * 1.5,
              ),
              child: HugeIcon(icon: HugeIcons.strokeRoundedBuilding05, color: Colors.black)
            //  child: Image.asset(AppImage.logo,height: MediaQuery.of(context).size.height*0.20,),
          ),
          gapH16,
          Expanded(
            child: SizedBox(
              width: 48,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,


                children: [
                  IconButton(

                      onPressed: (){}, icon: Icon(Icons.add)),

                  IconTile(
                    isActive: true,
                    activeIconSrc: "assets/icons/activity_light.svg",
                    inactiveIconSrc: "assets/icons/home_light.svg",
                    onPressed: () {},
                  ),
                  gapH4,
                  IconTile(
                    isActive: false,
                    activeIconSrc: "assets/icons/diamond_filled.svg",
                    inactiveIconSrc: "assets/icons/diamond_light.svg",
                    onPressed: () {},
                  ),
                  gapH4,
                  IconTile(
                    isActive: false,
                    activeIconSrc: "assets/icons/profile_circled_filled.svg",
                    inactiveIconSrc: "assets/icons/profile_circled_light.svg",
                    onPressed: () {},
                  ),
                  gapH4,
                  IconTile(
                    isActive: false,
                    activeIconSrc: "assets/icons/store_light.svg",
                    inactiveIconSrc: "assets/icons/store_filled.svg",
                    onPressed: () {},
                  ),
                  gapH4,
                  IconTile(
                    isActive: false,
                    activeIconSrc: "assets/icons/pie_chart_filled.svg",
                    inactiveIconSrc: "assets/icons/pie_chart_light.svg",
                    onPressed: () {},
                  ),
                  gapH4,
                  IconTile(
                    isActive: false,
                    activeIconSrc: "assets/icons/promotion_filled.svg",
                    inactiveIconSrc: "assets/icons/promotion_light.svg",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              IconTile(
                isActive: false,
                activeIconSrc: "assets/icons/arrow_forward_light.svg",
                onPressed: () {},
              ),
              const SizedBox(
                width: 48,
                child: Divider(thickness: 2),
              ),
              gapH4,
              IconTile(
                isActive: false,
                activeIconSrc: "assets/icons/help_light.svg",
                onPressed: () {},
              ),
              gapH4,
              // ThemeIconTile(
              //   isDark: false,
              //   onPressed: () {},
              // ),
              gapH16,
            ],
          )
        ],
      ),
    );
  }
}
