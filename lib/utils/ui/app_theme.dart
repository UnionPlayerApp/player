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

const Color primaryColor = Color(0xFFcc3030);
const Color primaryDarkColor = Color(0xFF940009);
const Color primaryLightColor = Color(0xFFff655a);

const Color secondaryColor = Color(0xFF32cdcd);
const Color secondaryDarkColor = Color(0xFF009b9c);
const Color secondaryLightColor = Color(0xFF73ffff);

const Color errorColor = Color(0xFFC5032B);

const Color colorOnPrimary = Colors.white;
const Color colorOnSecondary = Color(0xFF000000);

const Color backgroundColor = Color(0xFFF1F1F1);
const Color surfaceColor = Colors.white;

const defaultLetterSpacing = 0.03;