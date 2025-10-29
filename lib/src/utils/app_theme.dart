import 'package:flutter/material.dart';

class AppTheme {
  // Colors matching the React app's theme (slate, sky, etc.)
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);

  static const Color sky100 = Color(0xFFE0F2FE);
  static const Color sky400 = Color(0xFF38BDF8);
  static const Color sky500 = Color(0xFF0EA5E9);
  static const Color sky600 = Color(0xFF0284C7);

  static const Color green100 = Color(0xFFDCFCE7);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);

  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);

  static const Color yellow400 = Color(0xFFFACC15);

  static const Color purple500 = Color(0xFF8B5CF6);
  static const Color purple600 = Color(0xFF7C3AED);

  static const Color orange500 = Color(0xFFF97316);

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: slate50,
    primaryColor: sky500,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(248, 250, 252, 0.8), // slate-50/80
      elevation: 1,
      titleTextStyle: TextStyle(
        color: slate800,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: slate700),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sky500,
        foregroundColor: Colors.white,
        disabledBackgroundColor: slate200, // Disabled background color for light theme
        disabledForegroundColor: slate400, // Disabled text/icon color for light theme
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: slate900,
    primaryColor: sky400,
    fontFamily: 'Inter',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(15, 23, 42, 0.8), // slate-900/80
      elevation: 1,
      titleTextStyle: TextStyle(
        color: slate100,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: slate200),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sky500,
        foregroundColor: Colors.white,
        disabledBackgroundColor: slate700, // Disabled background color for dark theme
        disabledForegroundColor: slate500, // Disabled text/icon color for dark theme
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}