import 'package:flutter/material.dart';
import 'package:union_player_app/utils/constants/constants.dart';

extension ThemeModeExtension on ThemeMode {
  int get toInt {
    switch (this) {
      case ThemeMode.light:
        return themeLight;
      case ThemeMode.dark:
        return themeDark;
      case ThemeMode.system:
        return themeSystem;
    }
  }
}

extension IntExtension on int {
  ThemeMode get toThemeMode {
    switch (this) {
      case themeLight:
        return ThemeMode.light;
      case themeDark:
        return ThemeMode.dark;
      case themeSystem:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}

extension BrightnessExtensions on Brightness {
  ThemeMode get toThemeMode {
    switch (this) {
      case Brightness.light:
        return ThemeMode.light;
      case Brightness.dark:
        return ThemeMode.dark;
    }
  }
}
