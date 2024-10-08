import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.black,
      primary: Colors.grey[900]!,
      secondary: Colors.grey[800]!,
      tertiary: Colors.grey[400],
      tertiaryFixed: Colors.grey[300],
    ));
