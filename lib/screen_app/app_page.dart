import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/widgets/info_page.dart';
import 'package:union_player_app/utils/widgets/snack_bar.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<AppPage> {
  DateTime? _backPressTime;
  Widget? _currentPage;
  Duration _animationDuration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.logEvent(name: GA_APP_START);
    return BlocBuilder<AppBloc, AppState>(builder: (BuildContext context, AppState state) {
      log("AppState.build(), AppState = $state", name: LOG_TAG);
      return WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
          appBar: _createAppBar(state),
          body: _createPage(state),
          extendBody: true,
          floatingActionButton: _createFAB(state),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _createBottomNavigationBar(state),
        ),
      );
    });
  }

  BottomAppBar _createBottomNavigationBar(AppState state) => BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 7,
        child: Container(
          height: 60,
          child: Row(
            children: [
              //Left Tab Bar Icons
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buttonAppBar(context, state, 0, Icons.radio, StringKeys.home),
                    _buttonAppBar(context, state, 1, Icons.list_alt, StringKeys.schedule),
                  ],
                ),
              ),
              // Right Tab Bar Icons
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buttonAppBar(context, state, 2, Icons.markunread_mailbox_outlined, StringKeys.feedback),
                    _buttonAppBar(context, state, 3, Icons.settings_rounded, StringKeys.settings),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Expanded _buttonAppBar(BuildContext context, AppState state, int itemTab, IconData iconTab, StringKeys nameTab) {
    final color = state.navIndex == itemTab ? primaryColor : Colors.grey;
    return Expanded(
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        minWidth: 0,
        onPressed: () {
          context.read<AppBloc>().add(AppNavEvent(itemTab));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconTab, color: color),
            Text(translate(nameTab, context), style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    final DateTime now = DateTime.now();
    const duration = const Duration(seconds: 2);
    if (_backPressTime == null || now.difference(_backPressTime!) > duration) {
      _backPressTime = now;
      showSnackBar(context, StringKeys.press_again_to_exit, duration: duration);
      return Future.value(false);
    }
    get<AudioHandler>().stop();
    FirebaseAnalytics.instance.logEvent(name: GA_APP_STOP);
    return Future.value(true);
  }

  AppBar _createAppBar(AppState state) {
    final size = AppBar().preferredSize;
    return AppBar(
      title: _createTitle(state, size),
      leading: _createLeading(state),
    );
  }

  Widget _createTitle(AppState state, Size size) {
    final title = state.isScheduleLoaded ? _loadedTitle(state) : _unloadedTitle();
    final marquee = Marquee(
      text: title,
      startAfter: const Duration(seconds: 3),
      pauseAfterRound: const Duration(seconds: 3),
      blankSpace: 75.0,
    );
    return SizedBox(height: size.height, width: size.width, child: marquee);
  }

  String _loadedTitle(AppState state) {
    final presentArticle = translate(StringKeys.present_label, context);
    final presentArtist = state.presentArtist;
    final presentTitle = state.presentTitle;
    final nextArticle = translate(StringKeys.next_label, context);
    final nextArtist = state.nextArtist;
    final nextTitle = state.nextTitle;
    return "$presentArticle: $presentArtist - $presentTitle. $nextArticle: $nextArtist - $nextTitle";
  }

  String _unloadedTitle() {
    return translate(StringKeys.information_is_loading, context);
  }

  Widget _createLeading(AppState state) {
    late final String assetName;
    switch (state.audioQualityId) {
      case AUDIO_QUALITY_LOW:
        assetName = IC_AUDIO_QUALITY_LOW_WHITE;
        break;
      case AUDIO_QUALITY_MEDIUM:
        assetName = IC_AUDIO_QUALITY_MEDIUM_WHITE;
        break;
      case AUDIO_QUALITY_HIGH:
        assetName = IC_AUDIO_QUALITY_HIGH_WHITE;
        break;
      default:
        assetName = IC_AUDIO_QUALITY_DEFAULT_WHITE;
        break;
    }
    return MaterialButton(
      padding: EdgeInsets.only(left: 6.0, right: 6.0),
      child: Image.asset(assetName),
      onPressed: () {
        context.read<AppBloc>().add(AppAudioQualitySelectorEvent());
      },
    );
  }

  Widget _createPage(AppState state) {
    final navPage = _createNavPage(state.navIndex, !state.isAudioQualitySelectorOpen);
    final audioQualitySelector = _createAudioQualitySelector(state.isAudioQualitySelectorOpen);

    return Stack(children: [navPage, audioQualitySelector]);
  }

  Widget _createNavPage(int navIndex, bool isActive) {
    late final Widget navPage;
    switch (navIndex) {
      case 0:
        navPage = BlocProvider.value(value: get<MainBloc>(), child: get<MainPage>());
        break;
      case 1:
        navPage = BlocProvider.value(value: get<ScheduleBloc>(), child: get<SchedulePage>());
        break;
      case 2:
        navPage = BlocProvider.value(value: get<FeedbackBloc>(), child: get<FeedbackPage>());
        break;
      case 3:
        navPage = BlocProvider.value(value: get<SettingsBloc>(), child: get<SettingsPage>());
        break;
      default:
        navPage = getWithParam<InfoPage, List<String>>(["Ошибка навигации", "Экран не создан?"]);
        break;
    }

    final navPageAnimated = _currentPage == null
        ? AnimatedOpacity(opacity: isActive ? 1.0 : 0.2, duration: _animationDuration, child: navPage)
        : _currentPage.runtimeType == navPage.runtimeType
            ? navPage
            : AnimatedSwitcher(duration: _animationDuration, child: navPage);

    _currentPage = navPage;

    return AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.2,
        duration: _animationDuration,
        child: IgnorePointer(ignoring: !isActive, child: navPageAnimated));
  }

  Widget _createAudioQualitySelector(bool visible) {
    final children = [
      _createAudioQualitySelectorButton(IC_AUDIO_QUALITY_LOW, StringKeys.settings_quality_low, AUDIO_QUALITY_LOW),
      _createAudioQualitySelectorButton(
          IC_AUDIO_QUALITY_MEDIUM, StringKeys.settings_quality_medium, AUDIO_QUALITY_MEDIUM),
      _createAudioQualitySelectorButton(IC_AUDIO_QUALITY_HIGH, StringKeys.settings_quality_high, AUDIO_QUALITY_HIGH),
    ];

    final widget = Container(
      margin: EdgeInsets.all(6.0),
      child: Wrap(children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: children)]),
    );

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: _animationDuration,
      child: IgnorePointer(ignoring: !visible, child: widget),
    );
  }

  Widget _createAudioQualitySelectorButton(String assetName, StringKeys key, int audioQualityId) {
    final size = AppBar().preferredSize;

    final image = Container(
        padding: appAudioQualitySelectorPadding,
        child: SizedBox(
          height: size.height,
          width: size.height,
          child: Image.asset(assetName),
        ));

    final string = "${translate(StringKeys.settings_quality_label, context)} -> ${translate(key, context)}";

    final textStyle = Theme.of(context).textTheme.button == null
        ? null
        : Theme.of(context).textTheme.button!.copyWith(color: Colors.white);

    final text = Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6.0)),
          color: Colors.grey,
        ),
        margin: EdgeInsets.only(left: 6.0),
        padding: appAudioQualitySelectorPadding,
        child: Text(string, style: textStyle));

    final row = Row(mainAxisSize: MainAxisSize.min, children: [image, text]);

    return MaterialButton(
      child: row,
      padding: const EdgeInsets.all(0),
      onPressed: () => context.read<AppBloc>().add(AppAudioQualityButtonEvent(audioQualityId)),
    );
  }

  FloatingActionButton _createFAB(AppState state) => FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppFabEvent()),
        tooltip: 'Play / Stop',
        child: Icon(state.playingState ? Icons.stop_rounded : Icons.play_arrow_rounded),
      );
}
