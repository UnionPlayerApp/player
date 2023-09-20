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
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_colors.dart';
import 'package:union_player_app/utils/widgets/snack_bar.dart';

import '../screen_listen/listen_bloc.dart';
import '../screen_listen/listen_page.dart';
import '../utils/core/nav_type.dart';
import '../utils/core/string_keys.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<AppPage> {
  static const _animationDuration = Duration(milliseconds: 300);

  final _goToCurrentStreamController = StreamController<int>.broadcast();

  DateTime? _backPressTime;
  Widget? _currentPage;

  late final _listenPage = _blocPage<ListenPage, ListenBloc>();
  late final _schedulePage = _blocPage<SchedulePage, ScheduleBloc>(param: _goToCurrentStreamController.stream);
  late final _settingsPage = _blocPage<SettingsPage, SettingsBloc>();

  Widget _blocPage<P extends Widget, B extends Bloc>({dynamic param}) => BlocProvider(
        create: (_) => GetIt.I.get<B>(param1: param),
        child: GetIt.I.get<P>(param1: param),
      );

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: gaAppStart);
    return BlocBuilder<AppBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        return WillPopScope(
          onWillPop: () => _onWillPop(),
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: _body(state),
            bottomNavigationBar: _bottomNavigationBar(state),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar(AppState state) => BottomAppBar(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonAppBar(context, state, NavType.schedule, AppIcons.icSchedule, StringKeys.schedule),
              _buttonAppBar(context, state, NavType.listen, AppIcons.icListen, StringKeys.listen),
              _buttonAppBar(context, state, NavType.settings, AppIcons.icSettings, StringKeys.settings),
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
          const SizedBox(height: 8.0),
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

  Widget _body(AppState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(child: _createNavPage(state)),
    );
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
}
