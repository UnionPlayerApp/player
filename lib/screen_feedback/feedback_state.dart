import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  bool hasBanner = true;

  @override
  List<Object> get props => [hasBanner];
}

class AboutInfoLoadAwaitState extends FeedbackState {
  @override
  List<Object> get props => [hasBanner];
}

class AboutInfoLoadSuccessState extends FeedbackState{
  final String url;

  AboutInfoLoadSuccessState(this.url);

  @override
  List<Object> get props => [url, hasBanner];
}

class AboutInfoLoadErrorState extends FeedbackState {
  final String errorMessage;

  AboutInfoLoadErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage, hasBanner];
}