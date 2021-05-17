import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_feedback/feedback_event.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:union_player_app/utils/app_logger.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final AppLogger _logger;
  final SystemData _systemData;
  bool hasBanner = true;

  FeedbackBloc(this._logger, this._systemData)
      : super(AboutInfoUrlLoadAwaitState()) {
    add(InitialEvent());
  }

  Future<void> log(String message) async {
    return _logger.logDebug(message);
  }

  @override
  // ignore: must_call_super
  // ВНИМАНИЕ костыль
  // Не вызываю super.close(), т.к. этот метод срабатывает при выходе со страницы фидбека и
  // при возвращении на нее не позволяет собитиям попадать в метод mapEventToState()
  Future<void> close() {
    return log("CLOSE");
  }

  // Method for debug: called whenever an event is added to the Bloc:
  @override
  void onEvent(FeedbackEvent event) {
    super.onEvent(event);
    log("NEW EVENT: ${event.toString()}");
  }

  @override
  Stream<FeedbackState> mapEventToState(FeedbackEvent event) async* {
    if (event is InitialEvent) {
      yield AboutInfoUrlLoadAwaitState();
    }
    if (event is GotCurrentLocaleEvent){
      yield await _getAboutInfoUrl(event.locale, hasBanner);
    }
    if (event is WebViewLoadStartedEvent){
      yield WebViewLoadAwaitState(hasBanner, event.url);
    }
    if(event is WebViewLoadSuccessEvent){
      yield WebViewLoadSuccessState(hasBanner, event.url);
    }
    if(event is WebViewLoadErrorEvent){
      log("WebViewLoadErrorEvent is processing...");
      yield WebViewLoadErrorState(hasBanner,  event.errorDescription);
    }
    if (event is HideBannerButtonPressedEvent) {
      hasBanner = false;
      yield _getCurrentStateWithoutBanner(event.state);
    }
    if (event is WriteEmailButtonPressedEvent) {
      // OPEN MAIL CLIENT
    }
  }

  Future<FeedbackState> _getAboutInfoUrl(String locale, bool hasBanner) async {
    _logger.logDebug("Localization: $locale");
    switch (locale) {
      case "be_BY": return WebViewLoadAwaitState(hasBanner, _systemData.aboutData.urlBy);
      case "ru_RU": return WebViewLoadAwaitState(hasBanner, _systemData.aboutData.urlRu);
      default : return WebViewLoadAwaitState(hasBanner, _systemData.aboutData.urlEn);
      // default : return WebViewLoadAwaitState(hasBanner, "https://pub.dev");
    }
  }

  FeedbackState _getCurrentStateWithoutBanner(FeedbackState state) {
    FeedbackState newState;
    if (state is WebViewLoadSuccessState ) {
      newState = WebViewLoadSuccessState(
        false, state.url);
    }
    else if (state is WebViewLoadErrorState) {
      newState = WebViewLoadErrorState(
          false, state.errorType);
    }
    else if (state is WebViewLoadAwaitState) {
      newState = WebViewLoadAwaitState(false,
          state.url);
    }
    else {
      newState = AboutInfoUrlLoadAwaitState();
    }
    return newState;
  }

}
