import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_feedback/feedback_event.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:url_launcher/url_launcher.dart';

const _EMAIL_SCHEME = 'mailto';
const _EMAIL_SUBJECT = 'subject';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final AppLogger _logger;
  final SystemData _systemData;

  FeedbackBloc(this._logger, this._systemData) : super(AboutInfoUrlLoadAwaitState()) {
    add(InitialEvent());
  }

  Future<void> log(String message) async {
    return _logger.logDebug(message);
  }

  @override
  Future<void> close() {
    log("#CLOSE#");
    return super.close();
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
    if (event is GotCurrentLocaleEvent) {
      yield await _getAboutInfoUrl(event.locale);
    }
    if (event is WebViewLoadStartedEvent) {
      yield WebViewLoadAwaitState(event.url);
    }
    if (event is WebViewLoadSuccessEvent) {
      yield WebViewLoadSuccessState(event.url);
    }
    if (event is WebViewLoadErrorEvent) {
      log("WebViewLoadErrorEvent is processing...");
      yield ErrorState(event.errorDescription);
    }
    if (event is WriteEmailButtonPressedEvent) {
      final path = _systemData.emailData.mailingList.join(",");
      final query = "$_EMAIL_SUBJECT=${event.subject}";
      final url = Uri(scheme: _EMAIL_SCHEME, path: path, query: query).toString();
      launch(url);
    }
  }

  Future<FeedbackState> _getAboutInfoUrl(String locale) async {
    _logger.logDebug("Localization: $locale");
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
