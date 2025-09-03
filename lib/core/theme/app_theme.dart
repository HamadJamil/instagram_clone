import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.surfaceLight,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.black,
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
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.grey600,
      selectionColor: AppColors.grey300,
      selectionHandleColor: AppColors.grey400,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      labelStyle: TextStyle(color: AppColors.grey),
      floatingLabelStyle: TextStyle(backgroundColor: Colors.transparent),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        borderSide: BorderSide(color: Colors.red),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(color: AppColors.primary),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.black,
      unselectedItemColor: AppColors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 2,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.grey300,
      modalBackgroundColor: AppColors.grey300,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
    ),

    iconTheme: IconThemeData(color: AppColors.black),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.surfaceDark,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
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
    bottomNavigationBarTheme: light.bottomNavigationBarTheme.copyWith(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        backgroundColor: AppColors.grey600,
        foregroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.grey900,
      modalBackgroundColor: AppColors.grey900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
    ),

    iconTheme: IconThemeData(color: AppColors.white),
  );
}
