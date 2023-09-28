import 'package:flutter/material.dart';
import 'package:union_player_app/common/enums/string_keys.dart';

import '../constants/constants.dart';

const _themeSystem = 0;
const _themeLight = 1;
const _themeDark = 2;

const _themeDefault = _themeSystem;
const _themeDefaultLabelKey = StringKeys.settingsThemeSystem;

const _mapType2Int = {
  ThemeMode.system: _themeSystem,
  ThemeMode.light: _themeLight,
  ThemeMode.dark: _themeDark,
};

const _mapType2StringKeys = {
  ThemeMode.system: StringKeys.settingsThemeSystem,
  ThemeMode.light: StringKeys.settingsThemeLight,
  ThemeMode.dark: StringKeys.settingsThemeDark,
};

const _mapInt2Type = {
  _themeSystem: ThemeMode.system,
  _themeLight: ThemeMode.light,
  _themeDark: ThemeMode.dark,
};

extension ThemeModeExtension on ThemeMode {
  int get integer => _mapType2Int[this] ?? _themeDefault;

  StringKeys get labelKey => _mapType2StringKeys[this] ?? _themeDefaultLabelKey;
}

extension ThemeModeIntExtension on int {
  ThemeMode get themeMode => _mapInt2Type[this] ?? defaultThemeMode;
}
