import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {
  final bool hasBanner = true;

  @override
  List<Object> get props => [hasBanner];
}

class AboutInfoUrlLoadAwaitState extends FeedbackState {
  @override
  List<Object> get props => [hasBanner];
}

abstract class WebViewState extends FeedbackState {
  final String url = "";
  final int indexedStackPosition = 1;
}

class WebViewLoadAwaitState extends WebViewState{
  final bool hasBanner;
  final String url;
  final int indexedStackPosition = 1;

  WebViewLoadAwaitState(this.hasBanner, this.url);

  @override
  List<Object> get props => [url, hasBanner];
}

class WebViewLoadSuccessState extends WebViewState{
  final bool hasBanner;
  final String url;
  final int indexedStackPosition = 0;

  WebViewLoadSuccessState(this.hasBanner, this.url);

  @override
  List<Object> get props => [indexedStackPosition, hasBanner];
}

class WebViewLoadErrorState extends FeedbackState{
  final bool hasBanner;
  final String errorType;

  WebViewLoadErrorState(this.hasBanner, this.errorType);

  @override
  List<Object> get props => [hasBanner, errorType];
}
