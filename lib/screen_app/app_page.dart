import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
import 'package:union_player_app/screen_settings/settings_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/widgets/info_page.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/widgets/snack_bar.dart';

class AppPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<AppPage> {
  DateTime? _backPressTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) => WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                appBar: _createAppBar(state),
                body: _createPage(state),
                floatingActionButton: _createFAB(state),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: _createBottomNavigationBar(state),
              ),
            ));
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
                    _buttonAppBar(
                        context, state, 0, Icons.radio, StringKeys.home),
                    _buttonAppBar(
                        context, state, 1, Icons.list_alt, StringKeys.schedule),
                  ],
                ),
              ),
              // Right Tab Bar Icons
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buttonAppBar(context, state, 2,
                        Icons.markunread_mailbox_outlined, StringKeys.feedback),
                    _buttonAppBar(context, state, 3, Icons.settings_rounded,
                        StringKeys.settings),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Expanded _buttonAppBar(BuildContext context, AppState state, int itemTab,
      IconData iconTab, StringKeys nameTab) {
    final color = state.navIndex == itemTab ? Colors.red[800] : Colors.grey;
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
      showSnackBar(context, "Press one more time for exit", duration: duration);
      return Future.value(false);
    }
    return Future.value(true);
  }

  AppBar _createAppBar(AppState state) {
    final size = AppBar().preferredSize;
    return AppBar(
      title: _createTitle(state, size),
      leading: _createLeading(),
      actions: _createActions(state),
    );
  }

  Widget _createTitle(AppState state, Size size) {
    log("_createTitle()");
    log("state.isScheduleLoaded = ${state.isScheduleLoaded}");
    log("state.presentArtist = ${state.presentArtist}");
    log("state.presentTitle = ${state.presentTitle}");
    log("state.nextArtist = ${state.nextArtist}");
    log("state.nextTitle = ${state.nextTitle}");
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
    return translate(StringKeys.information_not_loaded, context);
  }

  Widget _createLeading() {
    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          child: CircleAvatar(
            backgroundImage: ExactAssetImage(APP_BAR_LOGO_IMAGE),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4.0),
          ),
        ));
  }

  List<Widget>? _createActions(AppState state) {
    List<Widget>? actions;
    switch (state.navIndex) {
      case 2:
        actions = [
          IconButton(
            icon: Icon(Icons.mail_rounded),
            onPressed: () {
              // OPEN MAIL CLIENT
            },
          )
        ];
        break;
    }
    return actions;
  }

  Widget _createPage(AppState state) {
    switch (state.navIndex) {
      case 0:
        // return BlocProvider(
        //     create: (context) => get<MainBloc>(),
        //     child: get<MainPage>());
        return BlocProvider.value(
            value: get<MainBloc>(),
            child: get<MainPage>());
      case 1:
        return BlocProvider(
            create: (context) => get<ScheduleBloc>(),
            child: get<SchedulePage>());
      case 2:
        return BlocProvider(
            create: (context) => get<FeedbackBloc>(),
            child: get<FeedbackPage>());
      case 3:
        return get<SettingsPage>();
      default:
        return getWithParam<InfoPage, List<String>>(
            ["Ошибка навигации", "Экран не создан?"]);
    }
  }

  FloatingActionButton _createFAB(AppState state) => FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppFabEvent()),
        tooltip: 'Play / Stop',
        child: Icon(
            state.playingState ? Icons.stop_rounded : Icons.play_arrow_rounded),
      );
}
