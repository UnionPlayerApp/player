import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {}

class InitialEvent extends FeedbackEvent {
  final Locale locale;

  InitialEvent({required this.locale});

  @override
  List<Object?> get props => [locale];
}

class WriteEmailButtonPressedEvent extends FeedbackEvent {
  final String subject;
  final String emailLaunchError;

  WriteEmailButtonPressedEvent(this.subject, this.emailLaunchError);

  @override
  List<Object?> get props => [subject, emailLaunchError];
}

class WebViewLoadSuccessEvent extends FeedbackEvent {
  @override
  List<Object?> get props => [];
}

class WebViewLoadErrorEvent extends FeedbackEvent {
  final String errorDescription;

  WebViewLoadErrorEvent(this.errorDescription);

  @override
  List<Object?> get props => [errorDescription];
}
