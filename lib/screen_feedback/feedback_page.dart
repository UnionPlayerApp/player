import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';
import 'package:union_player_app/utils/widgets/no_divider_banner.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:koin_flutter/koin_flutter.dart';
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
        Stack(
          children: [
            Positioned(
                top: (bannerHeight - bannerBorderRadius.y),
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: _getCurrentStateWidget(context, state)),
            Positioned(
                child: _createBanner(context, state)),
          ]
        );
    },
    bloc: get<FeedbackBloc>(),
  );
  }

  Widget _createBanner(BuildContext context, FeedbackState state) {
    return
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(bannerBorderRadius),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black54,
                    blurRadius: 5.h,
                )
              ],
            ),
            child:
               ClipRRect(
                  borderRadius: BorderRadius.only(bottomLeft: bannerBorderRadius, bottomRight: bannerBorderRadius) ,
                  child: NoDividerBanner(
                    Text(translate(StringKeys.message_us, context)),
                    CircleAvatar(child: Icon(Icons.mail_rounded)),
                    [
                      TextButton(
                        style: bannerButtonStyle(),
                        child: Text(
                            translate(StringKeys.write, context),
                        ),
                        onPressed: () {
                          _writeEmailBottomPressed(context);
                        },
                      ),
                    ],
                  )
                )
            ),
        ]
      );
  }

  void _writeEmailBottomPressed(BuildContext context){
    context.read<FeedbackBloc>().add(WriteEmailButtonPressedEvent());
  }

  void _getCurrentLocale(BuildContext context) async{
    _logger.logDebug("Locale = ${Localizations.localeOf(context).toString()}");
    Locale currentLocale = Localizations.localeOf(context);
    context.read<FeedbackBloc>().add(GotCurrentLocaleEvent(currentLocale.toString()));
  }

  _getCurrentStateWidget(BuildContext context, FeedbackState state){
    if (state is WebViewLoadSuccessState) {
      return _loadAboutInfoWidget(context, state);
    }
    else if(state is WebViewLoadErrorState){
      _logger.logDebug("State is WebViewLoadErrorState, load error Widget.");
      return _loadErrorWidget(context, state);
    }
    else if (state is AboutInfoUrlLoadAwaitState) {
      _getCurrentLocale(context);
      return _loadAwaitWidget();
    }
    else if (state is WebViewLoadAwaitState) {
      return _loadAboutInfoWidget(context, state);
    }
    else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Widget _loadAwaitWidget(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadErrorWidget(BuildContext context, WebViewLoadErrorState state){
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("${translate(StringKeys.loading_error, context)}"),
              Text(state.errorType),
            ]));
  }

  Widget _loadAboutInfoWidget(BuildContext context, WebViewState state) {
    return _createStackWithWebView(context, state);
  }

  _createStackWithWebView(BuildContext context, WebViewState state){
    Set<Factory<OneSequenceGestureRecognizer>> _gestureRecognizers =
    [Factory(() => EagerGestureRecognizer())].toSet();
    bool loadWithError = false;
    return
      IndexedStack(
        index: state.indexedStackPosition,
        children: <Widget>[
          WebView(
            key: _webViewKey,
            initialUrl: state.url,
            javascriptMode: JavascriptMode.unrestricted,
            gestureRecognizers: _gestureRecognizers,
            onPageStarted: (value) {
              _logger.logDebug("Loading about_page started...");
              context.read<FeedbackBloc>().add(WebViewLoadStartedEvent(state.url));
            },
            onPageFinished: (value) {
              _logger.logDebug("Loading about_page successfully finished!");
              // Hide loading indicator:
              if(!loadWithError) context.read<FeedbackBloc>().add(WebViewLoadSuccessEvent(state.url));
            },
            onWebResourceError: (WebResourceError error){
              _logger.logDebug("Loading about_page error! Type: ${error.errorType.toString()}");
              loadWithError = true;
              context.read<FeedbackBloc>().add(WebViewLoadErrorEvent(error.description.toString()));
              return;
            },
            onWebViewCreated: (WebViewController controller){
              // controller.
            },
          ),
          Container(
            child: Center(child: CircularProgressIndicator()),
          ),
        ]);
  }
}