import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../constants/constants.dart';

ThemeData appThemeLight() {
  final baseThemeData = ThemeData.light();
  return baseThemeData.copyWith(
    appBarTheme: _appBarTheme(baseThemeData.appBarTheme),
    bannerTheme: _appBannerTheme(baseThemeData.bannerTheme),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: secondaryColor,
      colorScheme: _appColorScheme.copyWith(secondary: secondaryColor),
      textTheme: ButtonTextTheme.normal,
    ),
    cardColor: surfaceColor,
    colorScheme: _appColorScheme.copyWith(secondary: secondaryColor),
    primaryColor: primaryColor,
    primaryColorDark: primaryDarkColor,
    primaryColorLight: primaryLightColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: _appTextTheme(baseThemeData.textTheme),
  );
}

ThemeData appThemeDark() {
  final baseThemeData = ThemeData.dark();
  return baseThemeData.copyWith(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryLightColor,
      unselectedItemColor: Colors.grey,
    ),
    colorScheme: _appColorSchemeDark,
  );
}

TextTheme _appTextTheme(TextTheme base) {
  return base.apply(
    fontFamily: 'Rubik',
  );
}

MaterialBannerThemeData _appBannerTheme(MaterialBannerThemeData base) {
  return base.copyWith(
    backgroundColor: primaryLightColor,
    contentTextStyle: const TextStyle(color: colorOnSecondaryWithAlfa),
  );
}

AppBarTheme _appBarTheme(AppBarTheme base) {
  return base.copyWith(centerTitle: true);
}

const _appColorScheme = ColorScheme(
  primary: primaryColor,
  secondary: secondaryColor,
  surface: surfaceColor,
  background: backgroundColor,
  error: errorColor,
  onPrimary: backgroundColor,
  onSecondary: backgroundColor,
  onSurface: secondaryDarkColor,
  onBackground: colorOnBackgroundLight,
  onError: colorOnPrimary,
  brightness: Brightness.light,
);

final _appColorSchemeDark = _appColorScheme.copyWith(onBackground: colorOnBackgroundDark);

const primaryColor = Color(0xFF003e8d);
const primaryDarkColor = Color(0xFF00195f);
const primaryLightColor = Color(0xFF4b68be);

const secondaryColor = Color(0xFFe8000a);
const secondaryDarkColor = Color(0xFFad0000);
const secondaryLightColor = Color(0xFFff5539);

const errorColor = Color(0xFFC5032B);

const colorOnPrimary = Colors.white;
const colorOnSecondary = Colors.white;
const colorOnBackgroundLight = Colors.black;
const colorOnBackgroundDark = Colors.grey;
const colorOnSecondaryWithAlfa = Color(0xCEFFFFFF);

const backgroundColor = Color(0xFFF1F1F1);
const surfaceColor = Colors.white;

const defaultLetterSpacing = 0.03;

ThemeData getThemeById(int themeId) {
  switch (themeId) {
    case themeLight:
      return appThemeLight();
    case themeDark:
      return appThemeDark();
    default:
      return _systemTheme();
  }
}

ThemeData _systemTheme() {
  switch (SchedulerBinding.instance.window.platformBrightness) {
    case Brightness.light:
      return appThemeLight();
    case Brightness.dark:
      return appThemeDark();
  }
}
