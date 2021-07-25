import 'package:flutter/cupertino.dart';

import 'app_localizations.dart';

String translate(StringKeys key, BuildContext context) {
  String stringKey = key.toString().substring(11,
      key.toString().length); // Здесь 11 - это кол-во символов в "StringKeys."
  String? translatedString = AppLocalizations.of(context)?.translate(stringKey);
  return translatedString ?? "NOT FOUND";
}

enum  StringKeys{
  app_title,

  empty,
  // FeedbackScreen
  message_us,
  write,
  hide,
  feedback_subject,
  feedback_email_launch_error,
  // AppScreen
  press_again_to_exit,
  // AppScreen - AppBar
  present_label,
  next_label,
  information_is_loading,
  information_not_loaded,
  // AppScreen - BottomNavigationBar
  home,
  schedule,
  feedback,
  settings,
  loading_error,
  any_error,
  // Settings - Theme
  settings_theme_label,
  settings_theme_light,
  settings_theme_dark,
  settings_theme_system,
  // Settings - Quality
  settings_quality_label,
  settings_quality_low,
  settings_quality_medium,
  settings_quality_high,
  settings_quality_auto,
  // Settings - Start Playing
  settings_start_playing_label,
  settings_start_playing_start,
  settings_start_playing_stop,
  settings_start_playing_last,
  // Settings - Language
  settings_lang_label,
  settings_lang_ru,
  settings_lang_be,
  settings_lang_en,
  settings_lang_system,
  // Strings for InfoPage for displaying when app is not initialized
  app_is_not_init_1,
  app_is_not_init_2,
  app_is_not_init_3,
  app_is_not_init_4,
  app_is_not_init_5,
  // Title for LoadingPage when app in initializing
  app_init_title,

  will_made_next_release,
}
