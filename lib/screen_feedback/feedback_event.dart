import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AboutInfoLoadEvent extends FeedbackEvent {}

class GotCurrentLocaleEvent extends FeedbackEvent {
  final String locale;

  GotCurrentLocaleEvent(this.locale);

  @override
  List<Object?> get props => [locale];
}

class WriteEmailButtonPressedEvent extends FeedbackEvent {}

class HideBannerButtonPressedEvent extends FeedbackEvent {}