import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_feedback/feedback_event.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:url_launcher/url_launcher.dart';

const _emailScheme = 'mailto';
const _emailSubject = 'subject';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SystemData _systemData;

  FeedbackBloc(this._systemData) : super(AboutInfoUrlLoadAwaitState()) {
    on<InitialEvent>(_onInitial);
    on<GotCurrentLocaleEvent>(_onGotCurrentLocale);
    on<WebViewLoadStartedEvent>(_onWebViewLoadStarted);
    on<WebViewLoadSuccessEvent>(_onWebViewLoadSuccess);
    on<WebViewLoadErrorEvent>(_onWebViewLoadError);
    on<WriteEmailButtonPressedEvent>(_onWriteEmailButtonPressed);

    add(InitialEvent());
  }

  FutureOr<void> _onInitial(InitialEvent event, Emitter<FeedbackState> emitter) {
    final newState = AboutInfoUrlLoadAwaitState();
    emitter(newState);
  }

  FutureOr<void> _onGotCurrentLocale(GotCurrentLocaleEvent event, Emitter<FeedbackState> emitter) async {
    final newState = await _getAboutInfoUrl(event.locale);
    emitter(newState);
  }

  FutureOr<void> _onWebViewLoadStarted(WebViewLoadStartedEvent event, Emitter<FeedbackState> emitter) {
    final newState = WebViewLoadAwaitState(event.url);
    emitter(newState);
  }

  FutureOr<void> _onWebViewLoadSuccess(WebViewLoadSuccessEvent event, Emitter<FeedbackState> emitter) {
    final newState = WebViewLoadSuccessState(event.url);
    emitter(newState);
  }

  FutureOr<void> _onWebViewLoadError(WebViewLoadErrorEvent event, Emitter<FeedbackState> emitter) {
    final newState = ErrorState(event.errorDescription);
    emitter(newState);
  }

  FutureOr<void> _onWriteEmailButtonPressed(WriteEmailButtonPressedEvent event, Emitter<FeedbackState> emitter) {
    final path = _systemData.emailData.mailingList.join(",");
    final query = "$_emailSubject=${event.subject}";
    final url = Uri(scheme: _emailScheme, path: path, query: query);
    launchUrl(url);
  }

  Future<FeedbackState> _getAboutInfoUrl(String locale) async {
    debugPrint("Localization: $locale");
    switch (locale) {
      case "be_BY":
        return WebViewLoadAwaitState(_systemData.aboutData.urlBy);
      case "ru_RU":
        return WebViewLoadAwaitState(_systemData.aboutData.urlRu);
      default:
        return WebViewLoadAwaitState(_systemData.aboutData.urlEn);
    }
  }
}
