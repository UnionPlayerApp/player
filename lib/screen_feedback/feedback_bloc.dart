import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_feedback/feedback_event.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:url_launcher/url_launcher.dart';


class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SystemData _systemData;

  FeedbackBloc(this._systemData)
      : super(AboutInfoUrlLoadAwaitState()) {
    add(InitialEvent());
  }

  @override
  Stream<FeedbackState> mapEventToState(FeedbackEvent event) async* {
    if (event is InitialEvent) {
      yield AboutInfoUrlLoadAwaitState();
    }
    if (event is GotCurrentLocaleEvent){
      yield await _getAboutInfoUrl(event.locale);
    }
    if (event is WebViewLoadStartedEvent){
      yield WebViewLoadAwaitState(event.url);
    }
    if(event is WebViewLoadSuccessEvent){
      yield WebViewLoadSuccessState(event.url);
    }
    if(event is WebViewLoadErrorEvent){
      yield WebViewLoadErrorState(event.errorDescription);
    }
    if (event is WriteEmailButtonPressedEvent) {
      if (_systemData.emailData.mailingList.isEmpty) {
        yield MailingListEmptyState();
      } else {
        final Uri _emailLaunchUri = Uri(
            scheme: 'mailto',
            path: _createMailingListString(),
            queryParameters: {
              'subject': ''
            }
        );
        launch(_emailLaunchUri.toString());
      }
    }
  }

  Future<FeedbackState> _getAboutInfoUrl(String locale) async {
    switch (locale) {
      case "be_BY": return WebViewLoadAwaitState(_systemData.aboutData.urlBy);
      case "ru_RU": return WebViewLoadAwaitState(_systemData.aboutData.urlRu);
      default : return WebViewLoadAwaitState(_systemData.aboutData.urlEn);
    }
  }

  String _createMailingListString() {
    assert(_systemData.emailData.mailingList.isNotEmpty);

    final path = StringBuffer(_systemData.emailData.mailingList[0]);
    int index = 1;
    while (index < _systemData.emailData.mailingList.length) {
      path.write(",");
      path.write(_systemData.emailData.mailingList[index]);
      index++;
    }

    return path.toString();
  }

}
