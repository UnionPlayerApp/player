import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_feedback/feedback_event.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _emailScheme = 'mailto';
const _emailSubject = 'subject';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SystemData _systemData;

  FeedbackBloc(this._systemData) : super(const FeedbackLoadingState()) {
    on<InitialEvent>(_onInitial);
    on<WebViewLoadSuccessEvent>(_onWebViewLoadSuccess);
    on<WebViewLoadErrorEvent>(_onWebViewLoadError);
    on<WriteEmailButtonPressedEvent>(_onWriteEmailButtonPressed);
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
    )
    ..loadRequest(Uri.parse('https://flutter.dev'));

  FutureOr<void> _onInitial(InitialEvent event, Emitter<FeedbackState> emitter) {
    emitter(const FeedbackLoadingState());
    final url = _urlByLocale(event.locale);
    final uri = Uri.parse(url);
    _webViewController.loadRequest(uri);
  }

  FutureOr<void> _onWebViewLoadSuccess(WebViewLoadSuccessEvent event, Emitter<FeedbackState> emitter) {
    emitter(FeedbackWebViewState(controller: _webViewController));
  }

  FutureOr<void> _onWebViewLoadError(WebViewLoadErrorEvent event, Emitter<FeedbackState> emitter) {
    emitter(FeedbackErrorState(event.errorDescription));
  }

  FutureOr<void> _onWriteEmailButtonPressed(WriteEmailButtonPressedEvent event, Emitter<FeedbackState> emitter) {
    final path = _systemData.emailData.mailingList.join(",");
    final query = "$_emailSubject=${event.subject}";
    final url = Uri(scheme: _emailScheme, path: path, query: query);
    launchUrl(url);
  }

  String _urlByLocale(Locale locale) {
    debugPrint("locale.countryCode: ${locale.countryCode}");
    switch (locale.countryCode) {
      case "BY":
        return _systemData.aboutData.urlBy;
      case "RU":
        return _systemData.aboutData.urlRu;
      case "EN":
      default:
        return _systemData.aboutData.urlEn;
    }
  }
}
