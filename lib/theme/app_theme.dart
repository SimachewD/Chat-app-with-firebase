import 'package:flutter/material.dart';
import 'theme_data.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.purple,
      scaffoldBackgroundColor: AppThemeData.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppThemeData.appBarColor,
        titleTextStyle: AppThemeData.appBarTitleTextStyle,
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.purple, width: 2.0),
        ),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(8.0),
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppThemeData.buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: Colors.white70, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.white60),
        bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
        ),
      ),
      cardTheme: const CardTheme(
        color: Color(0xFF1E1E1E),
        elevation: 4,
        margin: EdgeInsets.all(8.0),
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
