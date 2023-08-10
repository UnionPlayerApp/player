import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {}

class AboutInfoUrlLoadAwaitState extends FeedbackState {
  @override
  List<Object> get props => [];
}

abstract class WebViewState extends FeedbackState {
  final String url;
  final int indexedStackPosition;

  WebViewState({this.url = "", this.indexedStackPosition = 1});

  @override
  List<Object?> get props => [url, indexedStackPosition];
}

class WebViewLoadAwaitState extends WebViewState {
  WebViewLoadAwaitState(String url) : super(url: url);
}

class WebViewLoadSuccessState extends WebViewState {
  WebViewLoadSuccessState(String url) : super(url: url, indexedStackPosition: 0);
}

class ErrorState extends FeedbackState {
  final String errorType;

  ErrorState(this.errorType);

  @override
  List<Object> get props => [errorType];
}
