import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/enums/language_type.dart';
import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:union_player_app/common/enums/start_playing_type.dart';
import 'package:union_player_app/common/enums/theme_mode.dart';

import '../common/core/exceptions.dart';
import '../common/core/typedefs.dart';

class SPManager {
  final SharedPreferences _prefs;

  static Future<SPManager> createInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SPManager._(prefs);
  }

  const SPManager._(this._prefs);

  JsonMap _decodeJson(String? value, String methodName, String key) {
    try {
      return value == null ? null : json.decode(value);
    } catch (_) {
      throw MsgException("SPManager $methodName() error => key: $key, value: $value is not valid json string");
    }
  }

  JsonMap readJson(String key) => _decodeJson(_prefs.getString(key), "readJson", key);

  Future<bool> writeJson(String key, JsonMap jsonMap) => _prefs.setString(key, json.encode(jsonMap));

  List<JsonMap> readJsonList(String key) {
    final stringList = _prefs.getStringList(key);
    return stringList == null
        ? []
        : stringList.map((item) => _decodeJson(item, "readJsonList", key)).toList(growable: false);
  }

  Future<bool> writeJsonList(String key, List<JsonMap> jsonList) {
    final stringList = jsonList.map((item) => json.encode(item)).toList(growable: false);
    return _prefs.setStringList(key, stringList);
  }

  bool? getBoolValue(String key) => _prefs.getBool(key);

  int? getIntValue(String key) => _prefs.getInt(key);

  String? getStringValue(String key) => _prefs.getString(key);

  double? getDoubleValue(String key) => _prefs.getDouble(key);

  bool containsKey(String key) => _prefs.getString(key) != null;

  Future<bool> removeValue(String key) => _prefs.remove(key);

  Future<bool> setIntValue(String key, int value) => _prefs.setInt(key, value);

  Future<bool> setStringValue(String key, String value) => _prefs.setString(key, value);

  Future<bool> setBoolValue(String key, bool value) => _prefs.setBool(key, value);

  void debugPrintContent({String? tag}) {
    final keys = _prefs.getKeys();
    final tagText = tag == null ? "" : "$tag: ";
    if (keys.isEmpty) {
      debugPrint("${tagText}shared preferences is empty");
    } else {
      debugPrint("${tagText}shared preferences contains ${keys.length} elements:\n");
      var count = 0;
      for (var key in keys) {
        debugPrint("${++count} => key: $key, value: ${_prefs.get(key)}\n");
      }
    }
  }

  bool readIsPlaying() => _prefs.getBool(keyIsPlaying) ?? defaultIsPlaying;

  StartPlayingType readStartPlayingType() =>
      _prefs.getInt(keyStartPlaying)?.startPlayingType ?? defaultStartPlayingType;

  SoundQualityType readSoundQualityType() =>
      _prefs.getInt(keySoundQuality)?.soundQualityType ?? defaultSoundQualityType;

  LanguageType readLanguageType() => _prefs.getInt(keyLanguage)?.languageType ?? defaultLanguageType;

  ThemeMode readThemeMode() => _prefs.getInt(keyTheme)?.themeMode ?? defaultThemeMode;

  Future<bool> writeIsPlaying(bool isPlaying) => _prefs.setBool(keyIsPlaying, isPlaying);

  Future<bool> writeStartPlayingType(StartPlayingType startPlayingType) => _prefs.setInt(
        keyIsPlaying,
        startPlayingType.integer,
      );

  Future<bool> writeSoundQualityType(SoundQualityType soundQualityType) => _prefs.setInt(
        keySoundQuality,
        soundQualityType.integer,
      );

  Future<bool> writeLanguageType(LanguageType languageType) => _prefs.setInt(keyLanguage, languageType.integer);

  Future<bool> writeThemeMode(ThemeMode themeMode) => _prefs.setInt(keyTheme, themeMode.integer);
}
