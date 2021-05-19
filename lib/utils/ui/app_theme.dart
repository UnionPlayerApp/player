import 'package:flutter/material.dart';

ThemeData buildUnionRadioTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _unionRadioColorScheme,
    primaryColorDark: primaryDarkColor,
    primaryColor: primaryColor,
    primaryColorLight: primaryLightColor,
    accentColor: secondaryColor,
    buttonColor: secondaryDarkColor,
    scaffoldBackgroundColor: backgroundColor,
    cardColor: surfaceColor,
    buttonTheme: ButtonThemeData(
        buttonColor: secondaryColor,
      colorScheme: _unionRadioColorScheme.copyWith(secondary: secondaryColor),
      textTheme: ButtonTextTheme.normal,
    ),
    textTheme: _buildUnionPlayerTextTheme(base.textTheme),
    bannerTheme: _buildUnionPlayerBannerTheme(base.bannerTheme),
    appBarTheme: _buildUnionPlayerAppBarTheme(base.appBarTheme),
  );
}

TextTheme _buildUnionPlayerTextTheme(TextTheme base) {
  return base.apply(
    fontFamily: 'Rubik',
  );
}

MaterialBannerThemeData _buildUnionPlayerBannerTheme(MaterialBannerThemeData base){
  return base.copyWith(
    backgroundColor: primaryLightColor,
  );
}

AppBarTheme _buildUnionPlayerAppBarTheme(AppBarTheme base){
  return base.copyWith(centerTitle: true);
}


const ColorScheme _unionRadioColorScheme = ColorScheme(
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
// const Color colorOnSecondary = Color(0xFF000000);

const Color backgroundColor = Color(0xFFF1F1F1);
const Color surfaceColor = Colors.white;

const defaultLetterSpacing = 0.03;