import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    required this.onPressed,
    this.titleColor,
    this.backgroundColor,
    this.borderColor,
    this.iconName, // Add an iconName parameter
    Key? key,
  }) : super(key: key);

  final String title;
  final GestureTapCallback onPressed;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? borderColor;
  final String? iconName; // Declare the iconName parameter

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? AppColors.primaryColor;
    final buttonBorderColor = borderColor ?? Colors.transparent;
    final buttonTitleColor = titleColor ?? AppColors.textWhiteColor;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 42.0,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: buttonBorderColor, // Border color
            width: 1.0, // Border width
          ),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (iconName != null) // Conditionally display the Icon
                getIconWithSize(iconName ?? '', 20, 20),
              const SizedBox(width: 8.0), // Add spacing between Icon and Text
              Text(
                title,
                style: AppFonts.buttonTitleStyle(color: buttonTitleColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
