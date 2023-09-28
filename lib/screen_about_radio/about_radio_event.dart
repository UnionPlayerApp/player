import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class AboutRadioEvent extends Equatable {}

class InitialEvent extends AboutRadioEvent {
  final Locale locale;

  InitialEvent({required this.locale});

  @override
  List<Object?> get props => [locale];
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
