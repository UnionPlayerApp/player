import 'package:flutter/cupertino.dart';

import 'app_localizations.dart';

String translate(StringKeys key, BuildContext context){
  String stringKey = key.toString().substring(11, key.toString().length); // Здесь 11 - это кол-во символов в "StringKeys."
  String? translatedString = AppLocalizations.of(context)?.translate(stringKey);
  if (translatedString != null) { return translatedString; }
  else { return "NOT FOUND"; }
}

enum  StringKeys{
  // FeedbackScreen
  message_us,
  write,
  hide,

  // BottomNavigationBar
  home,
  schedule,
  feedback,
  settings,

  loading_error
}

