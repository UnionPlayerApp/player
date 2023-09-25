import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_player_app/utils/core/extensions.dart';

import '../constants/constants.dart';

Future<int?> readIntFromSharedPreferences(String key, {int? defaultValue}) async {
  return SharedPreferences.getInstance().then((sp) => sp.getInt(key) ?? defaultValue);
}

Future<bool> writeBoolToSharedPreferences(String key, bool value) async {
  return SharedPreferences.getInstance().then((sp) => sp.setBool(key, value));
}

Future<bool> writeIntToSharedPreferences(String key, int value) async {
  return SharedPreferences.getInstance().then((sp) => sp.setInt(key, value));
}

class SpManager {
  static Future<ThemeMode> readThemeMode() async {
    final themeId = await readIntFromSharedPreferences(keyTheme) ?? defaultThemeId;
    return themeId.toThemeMode;
  }
}
