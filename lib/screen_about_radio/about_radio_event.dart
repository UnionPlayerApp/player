import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class AboutRadioEvent extends Equatable {}

class InitialEvent extends AboutRadioEvent {
  final Color backgroundColor;
  final Locale locale;
  final bool isDarkMode;

  InitialEvent({required this.locale, required this.isDarkMode, required this.backgroundColor});

  @override
  List<Object?> get props => [locale, isDarkMode, backgroundColor];

  @override
  String toString() => "${super.toString()}, "
      "backgroundColor: $backgroundColor, "
      "locale: $locale, "
      "isDarkMode: $isDarkMode";
}

class WebViewLoadSuccessEvent extends AboutRadioEvent {
  @override
  List<Object?> get props => [];
}

class WebViewLoadErrorEvent extends AboutRadioEvent {
  final String errorDescription;

  WebViewLoadErrorEvent(this.errorDescription);

  @override
  List<Object?> get props => [errorDescription];
}
