import 'package:flutter/material.dart';

import '../configs/app_colors.dart';

TextStyle myText({Color color = AppColors.textColorb1, FontWeight fontWeight = FontWeight.w300, double? fontSize}){
  return TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize??12);
}
TextStyle myTextPrice({Color color = AppColors.textColorb1, FontWeight fontWeight = FontWeight.w300, double? fontSize}){
  return TextStyle(color: color, fontWeight: fontWeight, fontSize: fontSize??12, fontFamily: 'Lato');
}