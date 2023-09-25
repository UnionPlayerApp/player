import 'package:flutter/material.dart';
import 'package:union_player_app/utils/constants/constants.dart';

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
