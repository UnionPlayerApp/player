import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/screen_about_radio/about_radio_bloc.dart';
import 'package:union_player_app/screen_about_radio/about_radio_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common/constants/constants.dart';
import '../common/enums/string_keys.dart';
import 'about_radio_event.dart';

class AboutRadioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutRadioState();
}

class _AboutRadioState extends State<AboutRadioPage> {
  late final _bloc = context.read<AboutRadioBloc>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = Localizations.localeOf(context);
    _bloc.add(InitialEvent(locale: currentLocale));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 20.0,
          icon: SvgPicture.asset(AppIcons.icArrowBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          translate(StringKeys.aboutRadio, context),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: BlocBuilder<AboutRadioBloc, AboutRadioState>(
        builder: (context, state) => _stateWidget(context, state),
      ),
    );
  }

  Widget _stateWidget(BuildContext context, AboutRadioState state) {
    switch (state.runtimeType) {
      case AboutRadioWebViewState:
        state as AboutRadioWebViewState;
        return _webViewWidget(context, state);
      case AboutRadioErrorState:
        state as AboutRadioErrorState;
        return _errorWidget(context, state);
      case AboutRadioLoadingState:
      default:
        return _loadingWidget();
    }
  }

  Widget _loadingWidget() => const Center(child: CircularProgressIndicator());

  Widget _errorWidget(BuildContext context, AboutRadioErrorState state) {
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

  Widget _webViewWidget(BuildContext context, AboutRadioWebViewState state) {
    final gestureRecognizers = {Factory(() => EagerGestureRecognizer())};
    return Column(
      children: [
        const SizedBox(height: 30.0),
        _appLogoWidget(),
        Expanded(
          child: WebViewWidget(
            controller: state.controller,
            gestureRecognizers: gestureRecognizers,
          ),
        ),
      ],
    );
  }

  Widget _appLogoWidget() => Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppImages.imRadioLogo, width: 125.0, height: 125.0),
          Image.asset(AppImages.imCircle150Blur8),
        ],
      );
}
