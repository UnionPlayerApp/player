import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AboutInfoLoadEvent extends FeedbackEvent {}

class WriteEmailButtonPressedEvent extends FeedbackEvent {}

class HideBannerButtonPressedEvent extends FeedbackEvent {}