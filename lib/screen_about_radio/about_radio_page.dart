import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/widgets/about_widget.dart';
import 'package:union_player_app/screen_about_radio/about_radio_bloc.dart';
import 'package:union_player_app/screen_about_radio/about_radio_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common/constants/constants.dart';
import '../common/enums/string_keys.dart';
import '../common/widgets/app_logo_widget.dart';
import 'about_radio_event.dart';

class AboutRadioPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutRadioState();
}

class _AboutRadioState extends AboutWidgetState<AboutRadioPage> {
  late final _bloc = context.read<AboutRadioBloc>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc.add(InitialEvent(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isDarkMode: Get.isDarkMode,
      locale: Get.locale ?? defaultLocale,
    ));
  }

  @override
  StringKeys get titleKey => StringKeys.aboutRadio;

  @override
  Widget bodyBuilder(BuildContext context) => BlocBuilder<AboutRadioBloc, AboutRadioState>(
        builder: (context, state) => _stateWidget(context, state),
      );

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
    return Column(
      children: [
        SizedBox(height: 30.h),
        const AppLogoWidget(),
        Expanded(
          child: WebViewWidget(
            controller: state.controller,
            gestureRecognizers: const {},
          ),
        ),
      ],
    );
  }
}
