import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF405DE6),
      secondary: const Color(0xFF833AB4),
      surface: Colors.white,
      error: const Color(0xFFED4956),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      labelStyle: TextStyle(color: Colors.grey),
      border: InputBorder.none,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF405DE6),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.grey[600],
      selectionColor: Colors.grey[300],
      selectionHandleColor: Colors.grey[400],
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF405DE6),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: const Color(0xFF405DE6)),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF405DE6),
      secondary: const Color(0xFF833AB4),
      surface: const Color(0xFF121212),
      error: const Color(0xFFED4956),
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: light.appBarTheme.titleTextStyle?.copyWith(
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: light.inputDecorationTheme,
    textSelectionTheme: light.textSelectionTheme,
    filledButtonTheme: light.filledButtonTheme,
    outlinedButtonTheme: light.outlinedButtonTheme,
    textTheme: light.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
}
