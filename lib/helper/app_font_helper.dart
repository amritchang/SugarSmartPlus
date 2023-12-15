import 'package:flutter/material.dart';
import 'package:sugar_smart_assist/helper/app_color_helper.dart';

class AppFonts {
  static TextStyle buttonTitleStyle({
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: color ?? AppColors.textWhiteColor,
    );
  }

  static TextStyle buttonTitleBoldStyle({
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: color ?? AppColors.textWhiteColor,
    );
  }

  static TextStyle navTitleTextStyle({
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: color ?? AppColors.textBlackColor,
    );
  }

  static TextStyle tabBarTitleTextStyle({
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: color ?? AppColors.textBlackColor,
    );
  }

  static TextStyle screenTitleBoldTextStyle({
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.bold,
      fontSize: 23,
      color: color ?? AppColors.textWhiteColor,
    );
  }

  static TextStyle screenSubTitleTextStyle({
    Color? color,
    double? size,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: size ?? 14,
      color: color ?? AppColors.textGreyColor,
    );
  }

  static TextStyle menuTitleTextStyle({
    Color? color,
    double? size,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: size ?? 16,
      color: color ?? AppColors.textWhiteColor,
    );
  }

  static TextStyle titleBoldTextStyle({
    Color? color,
    double? size,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w600,
      fontSize: size ?? 16,
      color: color ?? AppColors.textWhiteColor,
    );
  }

  static TextStyle titleMediumTextStyle({
    Color? color,
    double? size,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      fontSize: size ?? 16,
      color: color ?? AppColors.textWhiteColor,
    );
  }

  static TextStyle titleTextStyle({
    Color? color,
    double? size,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: size ?? 16,
      color: color ?? AppColors.textWhiteColor,
    );
  }

  static TextStyle bodyTextStyle({
    Color? color,
    double? size,
  }) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.normal,
      fontSize: size ?? 14,
      color: color ?? AppColors.textGreyColor,
    );
  }
}
