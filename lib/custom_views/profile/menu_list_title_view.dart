import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';

Widget getMenuListTitleView(String title) {
  return Container(
    decoration: const BoxDecoration(
      color: AppColors.themeWhite, // Background color
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.menuTitleTextStyle(color: AppColors.textBlackColor),
        ),
      ],
    ),
  );
}
