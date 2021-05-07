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
  requiredErrorText,

  nameFormTitle,
  nameFormHint,

  emailFormTitle,
  emailFormHint,
  emailErrorText,

  phoneFormTitle,
  phoneFormHint,
  phoneErrorText,

  messageFormTitle,
  messageFormHint,
  messageMaxLengthError,

  formSuccessText,
  sendButtonText,
  aboutButtonText,

  // BottomNavigationBar
  home,
  schedule,
  feedback,
  settings,

  loading_error
}

