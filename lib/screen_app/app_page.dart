import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
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
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/ui/app_theme.dart';
import 'package:union_player_app/utils/widgets/info_page.dart';
import 'package:union_player_app/utils/widgets/snack_bar.dart';

import '../utils/widgets/anchored_overlay.dart';
import '../utils/widgets/center_about.dart';
import '../utils/widgets/fab_with_icons.dart';
import '../utils/widgets/flags_widget.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<AppPage> {
  DateTime? _backPressTime;
  Widget? _currentPage;
  static const _animationDuration = Duration(milliseconds: 300);
  final _goToCurrentStreamController = StreamController<void>();

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
            floatingActionButton: _fab(context, state),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: _bottomNavigationBar(state),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar(AppState state) => BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 7,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonAppBar(context, state, 0, Icons.radio, StringKeys.home),
              _buttonAppBar(context, state, 1, Icons.list_alt, StringKeys.schedule),
              _buttonAppBar(context, state, 2, Icons.markunread_mailbox_outlined, StringKeys.feedback),
              _buttonAppBar(context, state, 3, Icons.settings_rounded, StringKeys.settings),
              _fakeButtonAppBar(),
            ],
          ),
        ),
      );

  Widget _buttonAppBar(BuildContext context, AppState state, int itemTab, IconData iconTab, StringKeys nameTab) {
    final color = state.navIndex == itemTab
        ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
        : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor;
    return MaterialButton(
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
    );
  }

  Widget _fakeButtonAppBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(null),
        Text(""),
      ],
    );
  }

  Future<bool> _onWillPop() {
    final DateTime now = DateTime.now();
    const duration = Duration(seconds: 2);
    if (_backPressTime == null || now.difference(_backPressTime!) > duration) {
      _backPressTime = now;
      showSnackBar(context, messageKey: StringKeys.pressAgainToExit, duration: duration);
      return Future.value(false);
    }
    get<AudioHandler>().stop();
    FirebaseAnalytics.instance.logEvent(name: gaAppStop);
    return Future.value(true);
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
    late final Widget navPage;
    switch (state.navIndex) {
      case 0:
        navPage = BlocProvider.value(
          value: get<MainBloc>(),
          child: getWithParam<MainPage, Stream<void>>(_goToCurrentStreamController.stream),
        );
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

    final isActive = !state.isAudioQualitySelectorOpen;

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

    final textStyle = Theme.of(context).textTheme.button == null
        ? null
        : Theme.of(context).textTheme.button!.copyWith(color: Colors.white);

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

  Widget _fab(BuildContext context, AppState state) {
    final fabIconData = state.playingState ? Icons.stop_rounded : Icons.play_arrow_rounded;
    fabAction() => context.read<AppBloc>().add(AppFabPlayStopEvent());
    const fabTooltip = 'Play / Stop';

    const icons = [
      Icons.my_location_rounded,
    ];
    final actions = [
      () => _goToCurrentStreamController.add(null),
    ];
    const tooltips = [
      'Current item',
    ];

    return AnchoredOverlay(
      showOverlay: state.navIndex == 0,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(offset.dx, offset.dy - icons.length * 35.0),
          child: FabWithIcons(
            icons: icons,
            actions: actions,
            tooltips: tooltips,
            fabIcon: fabIconData,
            fabAction: fabAction,
            fabTooltip: fabTooltip,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: fabAction,
        tooltip: fabTooltip,
        elevation: 2.0,
        child: Icon(fabIconData),
      ),
    );
  }
}
