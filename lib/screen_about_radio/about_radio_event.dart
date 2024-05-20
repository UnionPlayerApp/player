import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../common/core/exceptions.dart';

abstract class AboutRadioEvent extends Equatable {
  const AboutRadioEvent();
}

class InitialEvent extends AboutRadioEvent {
  final Color backgroundColor;
  final Locale locale;
  final bool isDarkMode;

  const InitialEvent({required this.locale, required this.isDarkMode, required this.backgroundColor});

  @override
  List<Object?> get props => [locale, isDarkMode, backgroundColor];

  @override
  String toString() => "${super.toString()}, "
      "backgroundColor: $backgroundColor, "
      "locale: $locale, "
      "isDarkMode: $isDarkMode";
}

class WebViewLoadSuccessEvent extends AboutRadioEvent {
  const WebViewLoadSuccessEvent();

  @override
  List<Object?> get props => [];
}

class WebViewLoadErrorEvent extends AboutRadioEvent {
  final WebResourceException exception;

  const WebViewLoadErrorEvent({required this.exception});

  @override
  List<Object?> get props => [exception];
}
