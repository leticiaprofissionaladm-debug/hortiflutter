import 'package:flutter/material.dart';

class AppTheme{
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 3,
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      prefixIconColor: Colors.blue,
     ),
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(        
          padding: EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        )
      ),
  );
}