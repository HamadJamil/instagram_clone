import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
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

    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      labelStyle: TextStyle(color: AppColors.grey),
      border: InputBorder.none,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 45),
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
        minimumSize: const Size(double.infinity, 45),
        side: BorderSide(color: AppColors.primary),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.black,
      unselectedItemColor: AppColors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 2,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.black, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    ),

    iconTheme: IconThemeData(color: AppColors.black),
  );

  static final ThemeData dark = ThemeData(
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
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.white, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    ),

    iconTheme: IconThemeData(color: AppColors.white),
  );
}
