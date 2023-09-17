import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';
import 'package:union_player_app/utils/widgets/snack_bar.dart';

import '../screen_listen/listen_bloc.dart';
import '../screen_listen/listen_page.dart';
import '../utils/core/nav_type.dart';
import '../utils/core/string_keys.dart';
import '../utils/widgets/flags_widget.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<AppPage> {
  static const _animationDuration = Duration(milliseconds: 300);

  final _goToCurrentStreamController = StreamController<int>.broadcast();

  DateTime? _backPressTime;
  Widget? _currentPage;

  late final _listenPage = BlocProvider.value(
    value: GetIt.I.get<ListenBloc>(),
    child: GetIt.I.get<ListenPage>(param1: _goToCurrentStreamController.stream),
  );

  late final _schedulePage = BlocProvider.value(
    value: GetIt.I.get<ScheduleBloc>(),
    child: GetIt.I.get<SchedulePage>(param1: _goToCurrentStreamController.stream),
  );

  late final _settingsPage = BlocProvider.value(
    value: GetIt.I.get<SettingsBloc>(),
    child: GetIt.I.get<SettingsPage>(),
  );

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: gaAppStart);
    return BlocBuilder<AppBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        return WillPopScope(
          onWillPop: () => _onWillPop(),
          child: Scaffold(
            appBar: _appBar(context, state),
            body: _body(state),
            extendBody: true,
            bottomNavigationBar: _bottomNavigationBar(state),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar(AppState state) => BottomAppBar(
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonAppBar(context, state, NavType.schedule, icSchedule, StringKeys.schedule),
              _buttonAppBar(context, state, NavType.listen, icListen, StringKeys.listen),
              _buttonAppBar(context, state, NavType.settings, icSettings, StringKeys.settings),
            ],
          ),
        ),
      );

  Widget _buttonAppBar(BuildContext context, AppState state, NavType navType, String iconName, StringKeys nameTab) {
    final color = state.navType == navType
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
    return MaterialButton(
      padding: const EdgeInsets.all(0),
      minWidth: 0,
      onPressed: () {
        context.read<AppBloc>().add(AppNavEvent(navType));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(iconName, colorFilter: ColorFilter.mode(color!, BlendMode.srcIn)),
          Text(translate(nameTab, context), style: TextStyle(color: color)),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    const duration = Duration(seconds: 2);
    if (_backPressTime == null || now.difference(_backPressTime!) > duration) {
      _backPressTime = now;
      showSnackBar(context, messageKey: StringKeys.pressAgainToExit, duration: duration);
      return Future.value(false);
    } else {
      await GetIt.I.get<AudioHandler>().stop();
      FirebaseAnalytics.instance.logEvent(name: gaAppStop);
      return Future.value(true);
    }
  }

  AppBar _appBar(BuildContext context, AppState state) {
    return AppBar(
      titleSpacing: 0,
      title: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: kToolbarHeight,
          ),
          Align(alignment: Alignment.centerRight, child: _createTitle(context, state)),
          Align(alignment: Alignment.centerLeft, child: _createLeading(state)),
        ],
      ),
    );
  }

  Widget _createTitle(BuildContext context, AppState state) {
    final width = {
      FlagsWidgetMode.stop: MediaQuery.of(context).size.width,
      FlagsWidgetMode.play: MediaQuery.of(context).size.width - kToolbarHeight,
    };
    final mode = state.playingState ? FlagsWidgetMode.play : FlagsWidgetMode.stop;
    return FlagsWidget(
      width: width,
      height: kToolbarHeight,
      mode: mode,
      backgroundColor: primaryColor,
    );
  }

  Widget _createLeading(AppState state) {
    late final String assetName;
    switch (state.audioQualityId) {
      case audioQualityLow:
        assetName = icAudioQualityLowWhite;
        break;
      case audioQualityMedium:
        assetName = icAudioQualityMediumWhite;
        break;
      case audioQualityHigh:
        assetName = icAudioQualityHighWhite;
        break;
      default:
        assetName = icAudioQualityDefaultWhite;
        break;
    }
    return InkWell(
      onTap: () => context.read<AppBloc>().add(AppAudioQualitySelectorEvent()),
      child: SizedBox(
        width: kToolbarHeight,
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.asset(assetName),
        ),
      ),
    );
  }

  Widget _body(AppState state) {
    final navPage = _createNavPage(state);
    final audioQualitySelector = _createAudioQualitySelector(state.isAudioQualitySelectorOpen);

    return Stack(children: [navPage, audioQualitySelector]);
  }

  Widget _createNavPage(AppState state) {
    final navPage = _pageByNavType(state.navType);

    final isActive = !state.isAudioQualitySelectorOpen;

    final navPageAnimated = _currentPage == null
        ? AnimatedOpacity(opacity: isActive ? 1.0 : 0.2, duration: _animationDuration, child: navPage)
        : _currentPage == navPage
            ? navPage
            : AnimatedSwitcher(duration: _animationDuration, child: navPage);

    _currentPage = navPage;

    return AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.2,
        duration: _animationDuration,
        child: IgnorePointer(ignoring: !isActive, child: navPageAnimated));
  }

  Widget _pageByNavType(NavType navType) {
    switch (navType) {
      case NavType.listen:
        return _listenPage;
      case NavType.schedule:
        return _schedulePage;
      case NavType.settings:
        return _settingsPage;
    }
  }

  Widget _createAudioQualitySelector(bool visible) {
    final children = [
      _createAudioQualitySelectorButton(
        icAudioQualityLow,
        StringKeys.settingsQualityLow,
        audioQualityLow,
      ),
      _createAudioQualitySelectorButton(
        icAudioQualityMedium,
        StringKeys.settingsQualityMedium,
        audioQualityMedium,
      ),
      _createAudioQualitySelectorButton(
        icAudioQualityHigh,
        StringKeys.settingsQualityHigh,
        audioQualityHigh,
      ),
    ];

    final widget = Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: Wrap(children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)]),
    );

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: _animationDuration,
      child: IgnorePointer(ignoring: !visible, child: widget),
    );
  }

  Widget _createAudioQualitySelectorButton(String assetName, StringKeys key, int audioQualityId) {
    const size = kToolbarHeight - 2 * 6.0;

    final image = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: SizedBox(
          height: size,
          width: size,
          child: Image.asset(assetName),
        ));

    final string = "${translate(StringKeys.settingsQualityLabel, context)} -> ${translate(key, context)}";

    final textStyle = Theme.of(context).textTheme.labelLarge == null
        ? null
        : Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white);

    final text = Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          color: Colors.grey,
        ),
        margin: const EdgeInsets.only(left: 6.0),
        padding: appAudioQualitySelectorPadding,
        child: Text(string, style: textStyle));

    final row = Row(mainAxisSize: MainAxisSize.min, children: [image, text]);

    return MaterialButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => context.read<AppBloc>().add(AppAudioQualityButtonEvent(audioQualityId)),
      child: row,
    );
  }
}
