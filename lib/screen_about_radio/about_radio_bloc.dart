import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/common/core/exceptions.dart';
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

  var _isLoadError = false;

  late final _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          debugPrint("The About page loading progress: $progress");
        },
        onPageStarted: (url) {
          _isLoadError = false;
          debugPrint("The About page loading started, url: $url");
        },
        onPageFinished: (url) {
          final success = !_isLoadError;
          if (success) {
            add(const WebViewLoadSuccessEvent());
          }
          debugPrint("The About page loading finished, success: $success, url: $url");
        },
        onWebResourceError: (WebResourceError error) {
          _isLoadError = true;
          add(WebViewLoadErrorEvent(exception: WebResourceException(error: error)));
          debugPrint("The About page loading error => "
              "code: ${error.errorCode}, "
              "type: ${error.errorType}, "
              "description: ${error.description}, "
              "url: ${error.url}"
              "isForMainFrame: ${error.isForMainFrame}");
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
    _webViewController
      ..setBackgroundColor(event.backgroundColor)
      ..loadRequest(uri);
  }

  FutureOr<void> _onWebViewLoadSuccess(WebViewLoadSuccessEvent event, Emitter<AboutRadioState> emitter) {
    emitter(AboutRadioWebViewState(controller: _webViewController));
  }

  FutureOr<void> _onWebViewLoadError(WebViewLoadErrorEvent event, Emitter<AboutRadioState> emitter) {
    FirebaseCrashlytics.instance
        .recordError(event.exception, StackTrace.current)
        .then((_) => FirebaseCrashlytics.instance.sendUnsentReports());
    final errorBody = "url:\n"
        "${event.exception.error.url ?? "web url is unknown (null)"}\n\n"
        "description:\n"
        "${event.exception.error.description}";
    emitter(AboutRadioErrorState(errorBody));
  }

  String _buildUrl(Locale locale, bool isDarkMode) {
    final darkModeSuffix = isDarkMode ? "-dark" : "";
    final url = "${_systemData.aboutData.url}-${locale.languageCode.toLowerCase()}$darkModeSuffix";
    debugPrint("About Radio url: $url");
    return url;
  }
}
