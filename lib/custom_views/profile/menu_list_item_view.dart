import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/extension/image_extension.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';
import 'package:sugar_smart_assist/helper/app_font_helper.dart';
import 'package:sugar_smart_assist/models/menu.dart';
import 'package:sugar_smart_assist/custom_views/border_view.dart';

Widget getMenuListItemView(Menu menu,
    [bool shouldShowBorder = false,
    bool isSideArrow = false,
    String sideArrowHintText = '',
    GestureTapCallback? onPressed]) {
  return Container(
    padding: const EdgeInsets.all(0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getTemplatedIconWithSize(
                '${menu.defaultMenuIcon}', AppColors.themeBlack, 24, 24),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                '${menu.menuName}',
                style: AppFonts.menuTitleTextStyle(
                    color: AppColors.textBlackColor),
              ),
            ),
            Text(
              sideArrowHintText,
              style: AppFonts.menuTitleTextStyle(color: AppColors.primaryColor),
            ),
            getIconWithSize('side_arrow.png', 12, 12)
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, shouldShowBorder ? 12 : 0, 0, 0),
          child: getBorderLineView(shouldShowBorder ? null : Colors.transparent,
              shouldShowBorder ? 0.5 : 0.0, null),
        )
      ],
    ),
  );
}
