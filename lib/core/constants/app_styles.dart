import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const TextStyle headingTextStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );

  static const TextStyle subHeadingTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.blackColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.blackColor,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.whiteColor,
  );
  
  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 12.0,
    color: AppColors.errorColor,
  );
}
