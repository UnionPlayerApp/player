import 'package:flutter/cupertino.dart';

import 'app_localizations.dart';

String translate(StringKeys key, BuildContext context) {
  String stringKey = key.toString().substring(11,
      key.toString().length); // Здесь 11 - это кол-во символов в "StringKeys."
  String? translatedString = AppLocalizations.of(context)?.translate(stringKey);
  return translatedString ?? "NOT FOUND";
}

enum  StringKeys{
  appTitle,

  empty,
  // FeedbackScreen
  messageUs,
  write,
  hide,
  feedbackSubject,
  feedbackEmailLaunchError,
  // AppScreen
  pressAgainToExit,
  // AppScreen - AppBar
  prevLabel,
  presLabel,
  nextLabel,
  informationIsLoading,
  informationNotLoaded,
  // AppScreen - BottomNavigationBar
  home,
  schedule,
  feedback,
  settings,
  loadingError,
  anyError,
  // Settings - Theme
  settingsThemeLabel,
  settingsThemeLight,
  settingsThemeDark,
  settingsThemeSystem,
  // Settings - Quality
  settingsQualityLabel,
  settingsQualityLow,
  settingsQualityMedium,
  settingsQualityHigh,
  settingsQualityAuto,
  // Settings - Start Playing
  settingsStartPlayingLabel,
  settingsStartPlayingStart,
  settingsStartPlayingStop,
  settingsStartPlayingLast,
  // Settings - Language
  settingsLangLabel,
  settingsLangRU,
  settingsLangBY,
  settingsLangUS,
  settingsLangSystem,
  // Strings for the InfoPage for displaying when the App is not initialized
  appIsNotInit1,
  appIsNotInit2,
  appIsNotInit3,
  appIsNotInit4,
  appIsNotInit5,
  // Strings for the LoadingPage when the App is initializing
  appInitTitle,

  willMadeNextRelease,
  // Custom App Tracking Transparency Dialog
  trackingDialogTitle,
  trackingDialogText,
  trackingDialogButton,
}
