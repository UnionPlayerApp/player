import 'package:equatable/equatable.dart';
import 'package:flutter_html/flutter_html.dart';
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
  final Map<String, Style> styles;

  const AboutRadioHtmlState({required this.data, required this.styles});

  @override
  List<Object?> get props => [data, styles];
}

class AboutRadioErrorState extends AboutRadioState {
  final String body;

  const AboutRadioErrorState(this.body);

  @override
  List<Object> get props => [body];
}
