import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF076372),
    scaffoldBackgroundColor: const Color(0xFFEBE7E7),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF076372),
      iconTheme: IconThemeData(color: Color(0xFFEBE7E7)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF076372),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF076372),
        foregroundColor: const Color(0xFFEBE7E7),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFDADADA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF076372),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Color(0xFF348592),
      iconTheme: IconThemeData(color: Color(0xFFDADADA)),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFDADADA)),
      bodyMedium: TextStyle(color: Color(0xFFEBE7E7)),
      bodySmall: TextStyle(color: Color(0xFF348592)),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF348592),
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF348592),
        foregroundColor: const Color(0xFFDADADA),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF076372),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
