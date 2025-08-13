import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceLight,
      error: AppColors.error,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.black87),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      labelStyle: TextStyle(color: AppColors.grey),
      border: InputBorder.none,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.grey600,
      selectionColor: AppColors.grey300,
      selectionHandleColor: AppColors.grey400,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.primary),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: AppColors.white,
      elevation: 0,
      titleTextStyle: light.appBarTheme.titleTextStyle?.copyWith(
        color: AppColors.white,
      ),
    ),
    inputDecorationTheme: light.inputDecorationTheme,
    textSelectionTheme: light.textSelectionTheme,
    filledButtonTheme: light.filledButtonTheme,
    outlinedButtonTheme: light.outlinedButtonTheme,
    textTheme: light.textTheme.apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    ),
  );
}
