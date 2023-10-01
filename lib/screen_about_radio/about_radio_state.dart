import 'package:equatable/equatable.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class AboutRadioState extends Equatable {
  const AboutRadioState();
}

class AboutRadioLoadingState extends AboutRadioState {
  const AboutRadioLoadingState();

  @override
  List<Object> get props => [];
}

class AboutRadioWebViewState extends AboutRadioState {
  final WebViewController controller;

  const AboutRadioWebViewState({required this.controller});

  @override
  List<Object?> get props => [controller];
}

class AboutRadioErrorState extends AboutRadioState {
  final String errorType;

  const AboutRadioErrorState(this.errorType);

  @override
  List<Object> get props => [errorType];
}
