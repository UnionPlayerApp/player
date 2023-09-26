import 'package:flutter/material.dart';

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
