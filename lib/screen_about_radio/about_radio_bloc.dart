import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_about_radio/about_radio_event.dart';
import 'package:union_player_app/screen_about_radio/about_radio_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutRadioBloc extends Bloc<AboutRadioEvent, AboutRadioState> {
  final SystemData _systemData;

  AboutRadioBloc(this._systemData) : super(const AboutRadioLoadingState()) {
    on<InitialEvent>(_onInitial);
    on<WebViewLoadSuccessEvent>(_onWebViewLoadSuccess);
    on<WebViewLoadErrorEvent>(_onWebViewLoadError);
  }

  var _loadWithError = false;

  late final _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          debugPrint("The About page loading progress: $progress");
        },
        onPageStarted: (value) {
          debugPrint("The About page loading started. value: $value");
          _loadWithError = false;
        },
        onPageFinished: (value) {
          debugPrint("The About page loading finished. value: $value");
          if (!_loadWithError) {
            add(WebViewLoadSuccessEvent());
          }
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint("The About page loading error => type: ${error.errorType}, description: ${error.description}");
          _loadWithError = true;
          add(WebViewLoadErrorEvent(error.description));
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );

  FutureOr<void> _onInitial(InitialEvent event, Emitter<AboutRadioState> emitter) {
    emitter(const AboutRadioLoadingState());
    final url = _buildUrl(event.locale, event.isDarkMode);
    final uri = Uri.parse(url);
    _webViewController.loadRequest(uri);
  }

  FutureOr<void> _onWebViewLoadSuccess(WebViewLoadSuccessEvent event, Emitter<AboutRadioState> emitter) {
    emitter(AboutRadioWebViewState(controller: _webViewController));
  }

  FutureOr<void> _onWebViewLoadError(WebViewLoadErrorEvent event, Emitter<AboutRadioState> emitter) {
    emitter(AboutRadioErrorState(event.errorDescription));
  }

  String _buildUrl(Locale locale, bool isDarkMode) {
    final darkModeSuffix = isDarkMode ? "-dark" : "";
    final url = "${_systemData.aboutData.url}-${locale.languageCode.toLowerCase()}$darkModeSuffix";
    debugPrint("About Radio url: $url");
    return url;
  }
}
