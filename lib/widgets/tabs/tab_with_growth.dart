import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../configs/app_colors.dart';
import '../../configs/defaults.dart';
import '../../configs/ghaps.dart';
import '../../responsive.dart';



class TabWithGrowth extends StatelessWidget {
  const TabWithGrowth({
    super.key,
    required this.title,
    required this.amount,
    required this.growthPercentage,
    this.iconSrc = "assets/icons/shopping_bag_light.svg",
    this.isPositiveGrowth = true,
    this.iconBgColor = AppColors.secondaryBabyBlue,
  });
  final String title, amount, growthPercentage, iconSrc;
  final bool isPositiveGrowth;
  final Color iconBgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(
          horizontal: AppDefaults.padding,
          vertical:Responsive.isMobile(context)? AppDefaults.padding * 0.20:AppDefaults.padding * 0.75),
      width: double.infinity,
      // height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context))
            CircleAvatar(
              radius: 20,
              backgroundColor: iconBgColor,
              child: SvgPicture.asset(
                iconSrc,
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.titleLight,
                  BlendMode.srcIn,
                ),
              ),
            ),
          if (!Responsive.isMobile(context)) gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  amount,
                  style: Responsive.isDesktop(context)
                      ? Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(fontWeight: FontWeight.bold)
                      : Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
