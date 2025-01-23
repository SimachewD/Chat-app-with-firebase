import 'package:chatter_hive/core/constants/app_colors.dart';
import 'package:chatter_hive/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  // Background color
  static const Color backgroundColor = AppColors.backgroundColor;

  // App bar theme
  static const Color appBarColor = AppColors.appBarColor;
  static const TextStyle appBarTitleTextStyle = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.whiteColor,
  );

  // Button colors
  static const Color buttonColor = AppColors.buttonColor;

  // Text themes (Updated)
  static const TextTheme textTheme = TextTheme(
    displayLarge: AppStyles.headingTextStyle,
    displayMedium: AppStyles.subHeadingTextStyle,
    bodyLarge: AppStyles.bodyTextStyle,
    bodyMedium: AppStyles.bodyTextStyle,
  );

  // Icon colors
  static const Color iconColor = AppColors.primaryColor;

  // Input decoration theme (TextFormFields)
  static const Color inputFillColor = AppColors.whiteColor;
}
