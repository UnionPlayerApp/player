import 'package:flutter/cupertino.dart';
import 'package:union_player_app/util/localizations/app_localizations.dart';

String translate(StringKeys key, BuildContext context){
  String stringKey = key.toString().substring(11, key.toString().length); // Здесь 11 - это кол-во символов в "StringKeys."
  String? translatedString = AppLocalizations.of(context).translate(stringKey);
  if (translatedString != null) { return translatedString; }
  else { return ""; }
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

  // BottomNavigationBar
  home,
  schedule,
  feedback
}

