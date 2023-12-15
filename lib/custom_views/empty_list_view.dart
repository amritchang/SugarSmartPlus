import 'package:flutter/material.dart';

import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/custom_views/button/app_button.dart';
import 'package:sugar_smart_assist/helper/list_builder_extension.dart';

Widget getEmptyWidget(
    String title, String message, String buttonTitle, Function() onPressed) {
  return Center(
      child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style:
                AppFonts.buttonTitleBoldStyle(color: AppColors.textBlackColor)),
        Text(message,
            style: AppFonts.bodyTextStyle(color: AppColors.textBlackColor)),
        SizedBox(
          width: 100.0,
          child: AppButton(
            title: buttonTitle,
            onPressed: (onPressed),
            titleColor: AppColors.primaryColor,
            backgroundColor: Colors.transparent,
          ),
        ),
      ].withSpaceBetween(height: 10),
    ),
  ));
}
