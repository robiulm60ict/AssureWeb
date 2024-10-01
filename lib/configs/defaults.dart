import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppDefaults {
  static double bodyPadding     = 5;

  static const double padding = 14.0;
  static const double borderRadius = 8.0;
  static const double inputFieldRadius = 12.0;
  static double height(context) => MediaQuery.sizeOf(context).height;
  static double width(context)  => MediaQuery.sizeOf(context).width;
  static const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(AppDefaults.borderRadius),
      ),
      borderSide: BorderSide.none);
  static OutlineInputBorder focusedOutlineInputBorder = outlineInputBorder
      .copyWith(borderSide: BorderSide(width: 2, color: AppColors.primary));
}
