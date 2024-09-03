import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
      surface: Colors.grey[200]!,
      primary: Colors.grey[300]!,
      secondary: Colors.grey[400]!,
      tertiary: Colors.grey[600],
      tertiaryFixed: Colors.grey[700]
    )
);
