import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';

Widget getHeaderMenuView(String title,
    [bool isSideArrow = false,
    String sideArrowHintText = '',
    GestureTapCallback? onPressed]) {
  return Container(
    padding: const EdgeInsets.all(0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: AppFonts.menuTitleTextStyle(color: AppColors.textBlackColor),
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Row(
            children: [
              Text(
                sideArrowHintText,
                style:
                    AppFonts.menuTitleTextStyle(color: AppColors.primaryColor),
              ),
              GestureDetector(
                onTap: onPressed,
                child: isSideArrow
                    ? getIconWithSize('side_arrow.png', 12, 12)
                    : null,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
