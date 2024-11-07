import 'package:flutter/material.dart';

class ThemeSettings {
  static ThemeData ligthTheme() {
    final theme = ThemeData.light();
    return theme.copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  static ThemeData darkTheme() {
    final theme = ThemeData.dark();
    return theme.copyWith();
  }

  static ThemeData warmTheme() {
    final theme = ThemeData.light();
    return theme.copyWith();
  }
}
