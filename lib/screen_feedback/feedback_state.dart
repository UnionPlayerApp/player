import 'package:equatable/equatable.dart';

abstract class FeedbackState extends Equatable {

  @override
  List<Object> get props => [];
}

class AboutInfoUrlLoadAwaitState extends FeedbackState {
  @override
  List<Object> get props => [];
}

abstract class WebViewState extends FeedbackState {
  final String url = "";
  final int indexedStackPosition = 1;
}

class WebViewLoadAwaitState extends WebViewState{
  final String url;
  final int indexedStackPosition = 1;

  WebViewLoadAwaitState(this.url);

  @override
  List<Object> get props => [url];
}

class WebViewLoadSuccessState extends WebViewState{
  final String url;
  final int indexedStackPosition = 0;

  WebViewLoadSuccessState(this.url);

  @override
  List<Object> get props => [indexedStackPosition];
}

class WebViewLoadErrorState extends FeedbackState{
  final String errorType;

  WebViewLoadErrorState(this.errorType);

  @override
  List<Object> get props => [errorType];
}
