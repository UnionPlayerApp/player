import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'feedback_event.dart';

class FeedbackPage extends StatelessWidget {
  final _webViewKey = UniqueKey();
  final AppLogger _logger;

  FeedbackPage(this._logger);


  @override
  Widget build(BuildContext context) {
  return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (BuildContext context, FeedbackState state) {
        return
          Column(
            children: [
              _createBannerIfNotHidden(context, state),
              Expanded(
                child: _getCurrentStateWidget(context, state),
              )
            ],
          );
    },
    bloc: get<FeedbackBloc>(),
  );
  }

  Widget _createBannerIfNotHidden(BuildContext context, FeedbackState state) {
    Widget widget;
    if (state.hasBanner) {
      _logger.logDebug("Has banner? - ${state.hasBanner}");
      widget =
        MaterialBanner(
          content: Text(translate(StringKeys.message_us, context)),
          leading: CircleAvatar(child: Icon(Icons.mail_rounded)),
          actions: [
            TextButton(
              child: Text(translate(StringKeys.hide, context)),
              onPressed: () {
                _hideBanner(context);
              },
            ),
            TextButton(
              child: Text(translate(StringKeys.write, context)),
              onPressed: () {
                _writeEmailBottomPressed(context);
              },
            ),
          ],
        );
    } else {
      widget = Container();
    }
    return widget;
  }

  void _hideBanner(BuildContext context){
    context.read<FeedbackBloc>().add(HideBannerButtonPressedEvent());
  }

  void _writeEmailBottomPressed(BuildContext context){
    context.read<FeedbackBloc>().add(WriteEmailButtonPressedEvent());
  }

  _getCurrentStateWidget(BuildContext context, FeedbackState state){
    if (state is AboutInfoLoadAwaitState) {
      return _loadAboutInfoAwaitWidget();
    }
    if (state is AboutInfoLoadSuccessState){
      return _loadAboutInfoSuccessWidget(context, state);
    }
    if (state is AboutInfoLoadErrorState){
      return _loadAboutInfoErrorWidget(context, state);
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _loadAboutInfoAwaitWidget(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadAboutInfoErrorWidget(BuildContext context, AboutInfoLoadErrorState state) {
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${translate(StringKeys.loading_error, context)}"),
              Text(state.errorMessage),
            ]));
  }

  Widget _loadAboutInfoSuccessWidget(BuildContext context, AboutInfoLoadSuccessState state) {
    return _createWebView(context, state);
  }

  WebView _createWebView(BuildContext context, AboutInfoLoadSuccessState state){
    Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers =
    [Factory(() => EagerGestureRecognizer())].toSet();
    return
      WebView(
      key: _webViewKey,
      initialUrl: state.url,
      javascriptMode: JavascriptMode.unrestricted,
      gestureRecognizers: _gestureRecognizers,
      onPageStarted: (value) {},
      onPageFinished: (value) {},
    );
  }
}



