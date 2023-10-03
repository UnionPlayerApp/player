import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class AboutRadioEvent extends Equatable {}

class InitialEvent extends AboutRadioEvent {
  final Locale locale;
  final bool isDarkMode;

  InitialEvent({required this.locale, required this.isDarkMode});

  @override
  List<Object?> get props => [locale, isDarkMode];
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
