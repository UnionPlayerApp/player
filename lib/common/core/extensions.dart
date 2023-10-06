import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

extension ScreenUtilExtension on ScreenUtil {
  double get scale => 1 / min(scaleWidth, scaleHeight);
}

extension TextDirectionExtension on TextDirection {
  bool get isLtr => this == TextDirection.ltr;
}
