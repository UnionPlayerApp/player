import 'package:flutter/material.dart';

ThemeData createAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _appColorScheme,
    primaryColorDark: primaryDarkColor,
    primaryColor: primaryColor,
    primaryColorLight: primaryLightColor,
    accentColor: secondaryColor,
    buttonColor: secondaryDarkColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,
    buttonTheme: ButtonThemeData(
      buttonColor: secondaryColor,
      colorScheme: _appColorScheme.copyWith(secondary: secondaryColor),
      textTheme: ButtonTextTheme.normal,
    ),
    textTheme: _createTextTheme(base.textTheme),
    bannerTheme: _createBannerTheme(base.bannerTheme),
    appBarTheme: _createAppBarTheme(base.appBarTheme),
  );
}

ThemeData createAppThemeDark() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    colorScheme: _appColorScheme,
    // buttonTheme: ButtonThemeData(
    //   buttonColor: secondaryColor,
    //   colorScheme: _appColorScheme.copyWith(secondary: secondaryColor),
    //   textTheme: ButtonTextTheme.normal,
    // ),
  );
}

TextTheme _createTextTheme(TextTheme base) {
  return base.apply(
    fontFamily: 'Rubik',
  );
}

MaterialBannerThemeData _createBannerTheme(MaterialBannerThemeData base) {
  return base.copyWith(
    backgroundColor: primaryLightColor,
    contentTextStyle: TextStyle(color: colorOnSecondaryWithAlfa),
  );
}

AppBarTheme _createAppBarTheme(AppBarTheme base) {
  return base.copyWith(centerTitle: true);
}

const ColorScheme _appColorScheme = ColorScheme(
  primary: primaryColor,
  primaryVariant: primaryDarkColor,
  secondary: secondaryColor,
  secondaryVariant: secondaryDarkColor,
  surface: surfaceColor,
  background: backgroundColor,
  error: errorColor,
  onPrimary: backgroundColor,
  onSecondary: backgroundColor,
  onSurface: secondaryDarkColor,
  onBackground: backgroundColor,
  onError: colorOnPrimary,
  brightness: Brightness.light,
);

const Color primaryColor = Color(0xFF003e8d);
const Color primaryDarkColor = Color(0xFF00195f);
const Color primaryLightColor = Color(0xFF4b68be);

const Color secondaryColor = Color(0xFFe8000a);
const Color secondaryDarkColor = Color(0xFFad0000);
const Color secondaryLightColor = Color(0xFFff5539);

const Color errorColor = Color(0xFFC5032B);

const Color colorOnPrimary = Colors.white;
const Color colorOnSecondary = Colors.white;
const Color colorOnSecondaryWithAlfa = Color(0xCEFFFFFF);

const Color backgroundColor = Color(0xFFF1F1F1);
const Color surfaceColor = Colors.white;

const defaultLetterSpacing = 0.03;
