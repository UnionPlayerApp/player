import 'package:equatable/equatable.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();
}

class FeedbackLoadingState extends FeedbackState {
  const FeedbackLoadingState();

  @override
  List<Object> get props => [];
}

class FeedbackWebViewState extends FeedbackState {
  final WebViewController controller;

  const FeedbackWebViewState({required this.controller});

  @override
  List<Object?> get props => [controller];
}

class FeedbackErrorState extends FeedbackState {
  final String errorType;

  const FeedbackErrorState(this.errorType);

  @override
  List<Object> get props => [errorType];
}
