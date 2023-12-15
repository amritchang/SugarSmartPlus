import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';

Widget getBorderLineView(
    [Color? borderColor, double? borderWidth, double? borderRadius]) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: borderColor ?? AppColors.seperatorColor,
        width: borderWidth ?? 0.5,
      ),
      borderRadius:
          borderRadius == null ? null : BorderRadius.circular(borderRadius),
    ),
  );
}
