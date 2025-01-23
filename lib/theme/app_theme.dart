import 'package:flutter/material.dart';
import 'theme_data.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: AppThemeData.backgroundColor, // Corrected
      appBarTheme: const AppBarTheme(
        backgroundColor: AppThemeData.appBarColor,
        titleTextStyle: AppThemeData.appBarTitleTextStyle,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppThemeData.buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: AppThemeData.textTheme,
      iconTheme: const IconThemeData(color: AppThemeData.iconColor),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppThemeData.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
