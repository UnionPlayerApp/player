import 'package:flutter/cupertino.dart';

import 'app_localizations.dart';

String translate(StringKeys key, BuildContext context) {
  String stringKey = key.toString().substring(11,
      key.toString().length); // Здесь 11 - это кол-во символов в "StringKeys."
  String? translatedString = AppLocalizations.of(context)?.translate(stringKey);
  return translatedString ?? "NOT FOUND";
}

enum  StringKeys{
  empty,

  // FeedbackScreen
  message_us,
  write,
  hide,

  // AppBar
  present_label,
  next_label,
  information_is_loading,
  information_not_loaded,

  // BottomNavigationBar
  home,
  schedule,
  feedback,
  settings,
  loading_error,

  // Settings
  settings_theme_label,
  settings_theme_light,
  settings_theme_dark,
  settings_theme_system,

  settings_quality_label,
  settings_quality_low,
  settings_quality_medium,
  settings_quality_high,
  settings_quality_auto,

  settings_start_playing_label,
  settings_start_playing_start,
  settings_start_playing_stop,
  settings_start_playing_last,

  settings_lang_label,
  settings_lang_ru,
  settings_lang_be,
  settings_lang_en,
  settings_lang_system,
}
