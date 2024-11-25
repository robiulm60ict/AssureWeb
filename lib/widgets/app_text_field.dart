import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../configs/app_colors.dart';
import '../configs/defaults.dart';
import 'app_text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.textInputAction,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.readOnly = false,
    this.isBoldLabel = false,
    this.enabled = true,
    this.needLabel = true,
    this.fillColor,
    this.labelColor,
    this.hintColor,
    this.inputFormatters,
    this.textColor,
    this.isRequired,
    this.onTap
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String labelText;
  final String hintText;
  final bool? autofocus;
  final bool readOnly;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final Color? fillColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final bool? isRequired;
  final bool? enabled;
  final bool isBoldLabel;
  final bool needLabel;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (needLabel)
          Row(
            children: [
              Text(
                labelText,
                style: myText(
                  color: labelColor ?? AppColors.textColorb1,
                  fontWeight: isBoldLabel ? FontWeight.bold : FontWeight.w300,
                ),
              ),
              if (isRequired ?? false)
                SizedBox(
                  width: 5,
                ),
              if (isRequired ?? false)
                Text(
                  "*",
                  style:
                      myText(color: AppColors.red, fontWeight: FontWeight.w500),
                ),
            ],
          ),
        if (needLabel) SizedBox(height: AppDefaults.bodyPadding),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,

          onTap: onTap,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onChanged: onChanged,
          autofocus: autofocus ?? false,
          validator: validator,
          inputFormatters: inputFormatters,
          obscureText: obscureText ?? false,
          obscuringCharacter: '*',
          onEditingComplete: onEditingComplete,
          readOnly: readOnly,
          enabled: enabled,
          cursorColor: textColor ?? AppColors.textColorb1,
          style: myText(
              color: textColor ?? AppColors.textColorb1,
              fontWeight: FontWeight.w500),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            // labelText: labelText,
            contentPadding: EdgeInsets.all(20.0),
            hintText: hintText,
            isDense: true,
            filled: true,
            fillColor: fillColor ?? AppColors.bg,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // labelStyle: const TextStyle(color: AppColors.textColorb3),
            // hintStyle: TextStyle(
            //     fontWeight: FontWeight.w400,
            //     color: hintColor ?? Colors.grey.shade500),
            // errorBorder: OutlineInputBorder(
            //     borderRadius:
            //         BorderRadius.circular(AppDefaults.bodyPadding - 5),
            //     borderSide: BorderSide(color: AppColors.error, width: 0.5)),
            // focusedBorder: OutlineInputBorder(
            //     borderRadius:
            //         BorderRadius.circular(AppDefaults.bodyPadding - 5),
            //     borderSide:
            //         const BorderSide(color: AppColors.seed, width: 0.5)),
            // enabledBorder: OutlineInputBorder(
            //     borderRadius:
            //         BorderRadius.circular(AppDefaults.bodyPadding - 5),
            //     borderSide:
            //         const BorderSide(color: AppColors.primary, width: 0.5)),
            // focusedErrorBorder: OutlineInputBorder(
            //     borderRadius:
            //         BorderRadius.circular(AppDefaults.bodyPadding - 5),
            //     borderSide: BorderSide(color: AppColors.error, width: 0.5)),
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}

class AppTextFieldUnderline extends StatelessWidget {
  const AppTextFieldUnderline({
    required this.textInputAction,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.controller,
    super.key,
    this.onChanged,
    this.validator,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.onEditingComplete,
    this.autofocus,
    this.focusNode,
    this.readOnly = false,
    this.isBoldLabel = false,
    this.needLabel = true,
    this.fillColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.isRequired,
  });

  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String labelText;
  final String hintText;
  final bool? autofocus;
  final bool readOnly;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final Color? fillColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final bool? isRequired;
  final bool isBoldLabel;
  final bool needLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (needLabel)
          Row(
            children: [
              Text(
                labelText,
                style: myText(
                  color: labelColor ?? AppColors.textColorb1,
                  fontWeight: isBoldLabel ? FontWeight.bold : FontWeight.w300,
                ),
              ),
              if (isRequired ?? false)
                SizedBox(
                  width: 5,
                ),
              if (isRequired ?? false)
                Text(
                  "*",
                  style:
                      myText(color: AppColors.red, fontWeight: FontWeight.w500),
                ),
            ],
          ),
        if (needLabel) SizedBox(height: AppDefaults.bodyPadding / 2),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          onChanged: onChanged,
          autofocus: autofocus ?? false,
          validator: validator,
          obscureText: obscureText ?? false,
          obscuringCharacter: '*',
          onEditingComplete: onEditingComplete,
          readOnly: readOnly,
          cursorColor: textColor ?? AppColors.textColorb1,
          style: myText(
              color: textColor ?? AppColors.textColorb1,
              fontWeight: FontWeight.w500),
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            // labelText: labelText,
            hintText: hintText,
            isDense: true,
            filled: true,
            fillColor: fillColor ?? AppColors.bg,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // labelStyle: const TextStyle(color: AppColors.textColorb3),
            hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: hintColor ?? Colors.grey.shade500),
            errorBorder: UnderlineInputBorder(
                // borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide: BorderSide(color: AppColors.error, width: 0.5)),
            focusedBorder: const UnderlineInputBorder(
                // borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide: BorderSide(color: AppColors.seed, width: 0.5)),
            enabledBorder: const UnderlineInputBorder(
                // borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide:
                    BorderSide(color: AppColors.textColorb3, width: 0.5)),
            focusedErrorBorder: UnderlineInputBorder(
                // borderRadius: BorderRadius.circular(AppSizes.bodyPadding - 5),
                borderSide: BorderSide(color: AppColors.error, width: 0.5)),
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}
