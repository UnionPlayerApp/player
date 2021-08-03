import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends FeedbackEvent {}

class GotCurrentLocaleEvent extends FeedbackEvent {
  final String locale;

  GotCurrentLocaleEvent(this.locale);

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

class WebViewLoadStartedEvent extends FeedbackEvent {
  final String url;
  WebViewLoadStartedEvent(this.url);

  @override
  List<Object?> get props => [url];
}

class WebViewLoadSuccessEvent extends FeedbackEvent {
  final String url;
  WebViewLoadSuccessEvent(this.url);

  @override
  List<Object?> get props => [url];
}

class WebViewLoadErrorEvent extends FeedbackEvent {
  final String errorDescription;

  WebViewLoadErrorEvent(this.errorDescription);

  @override
  List<Object?> get props => [errorDescription];
}