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

class AboutRadioHtmlState extends AboutRadioState {
  final String data;

  const AboutRadioHtmlState({required this.data});

  @override
  List<Object?> get props => [data];
}

class AboutRadioErrorState extends AboutRadioState {
  final String body;

  const AboutRadioErrorState(this.body);

  @override
  List<Object> get props => [body];
}
