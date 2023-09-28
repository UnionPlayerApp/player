import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:union_player_app/screen_feedback/feedback_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_state.dart';
import 'package:union_player_app/common/dimensions/dimensions.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/ui/app_theme.dart';
import 'package:union_player_app/common/widgets/no_divider_banner.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common/enums/string_keys.dart';
import 'feedback_event.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedbackPage> {
  late final _bloc = context.read<FeedbackBloc>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Localizations.localeOf(context);
    _bloc.add(InitialEvent(locale: currentLocale));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) => Stack(
        children: [
          Positioned(
              top: (bannerHeight - bannerBorderRadius.y),
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: _stateWidget(context, state)),
          Positioned(
            child: _bannerWidget(context, state),
          ),
        ],
      ),
    );
  }

  Widget _bannerWidget(BuildContext context, FeedbackState state) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(bannerBorderRadius),
            boxShadow: [
              BoxShadow(color: Colors.black54, blurRadius: 5.h),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(bottomLeft: bannerBorderRadius, bottomRight: bannerBorderRadius),
            child: NoDividerBanner(
              Text(translate(StringKeys.messageUs, context), style: Theme.of(context).textTheme.bodyLarge),
              const CircleAvatar(child: Icon(Icons.mail_rounded)),
              [
                TextButton(
                  onPressed: () => _writeEmailBottomPressed(context),
                  child: Text(translate(StringKeys.write, context), style: const TextStyle(color: primaryDarkColor)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _writeEmailBottomPressed(BuildContext context) {
    final subject = translate(StringKeys.feedbackSubject, context);
    final emailLaunchError = translate(StringKeys.feedbackEmailLaunchError, context);
    _bloc.add(WriteEmailButtonPressedEvent(subject, emailLaunchError));
  }

  Widget _stateWidget(BuildContext context, FeedbackState state) {
    switch (state.runtimeType) {
      case FeedbackWebViewState:
        state as FeedbackWebViewState;
        return _webViewWidget(context, state);
      case FeedbackErrorState:
        state as FeedbackErrorState;
        return _errorWidget(context, state);
      case FeedbackLoadingState:
      default:
        return _loadingWidget();
    }
  }

  Widget _loadingWidget() => const Center(child: CircularProgressIndicator());

  Widget _errorWidget(BuildContext context, FeedbackErrorState state) {
    final headerStyle = Theme.of(context).textTheme.titleLarge;
    final bodyStyle = Theme.of(context).textTheme.bodyMedium;
    final header = Text(translate(StringKeys.anyError, context), style: headerStyle);
    final body = Text(state.errorType, style: bodyStyle, textAlign: TextAlign.center);
    const padding = EdgeInsets.all(8.0);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          header,
          Padding(padding: padding, child: body),
        ],
      ),
    );
  }

  Widget _webViewWidget(BuildContext context, FeedbackWebViewState state) {
    final gestureRecognizers = {Factory(() => EagerGestureRecognizer())};
    return WebViewWidget(
      controller: state.controller,
      gestureRecognizers: gestureRecognizers,
    );
  }
}
