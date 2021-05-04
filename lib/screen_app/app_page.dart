import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/info_page.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/snack_bar.dart';

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
              appBar: _createAppBar(context, state),
              body: _createPage(context, state),
              floatingActionButton: _createFAB(context, state),
              bottomNavigationBar: _createBottomNavigationBar(context, state),
            )));
  }

  Future<bool> _onWillPop() {
    final DateTime now = DateTime.now();
    final duration = Duration(seconds: 2);
    if (_backPressTime == null ||
        now.difference(_backPressTime!) > duration) {
      _backPressTime = now;
      showSnackBar(context, "Press one more time for exit", duration: duration);
      return Future.value(false);
    }
    return Future.value(true);
  }

  AppBar _createAppBar(BuildContext context, AppState state) => AppBar(
        title: _createTitle(context, state),
        leading: Container(
            padding: EdgeInsets.all(10.0),
            child: Image.asset(APP_BAR_LOGO_IMAGE, fit: BoxFit.fill)),
      );

  Widget _createTitle(BuildContext context, AppState state) {
    String data = "Unknown navigation index";
    switch (state.navIndex) {
      case 0:
        data = "Main page";
        break;
      case 1:
        data = "Schedule page";
        break;
      case 2:
        data = "Feedback page";
        break;
    }
    return Text(data);
  }

  Widget _createPage(BuildContext context, AppState state) {
    switch (state.navIndex) {
      case 0:
        return BlocProvider(
            create: (context) => get<MainBloc>(), child: get<MainPage>());
      case 1:
        return BlocProvider(
            create: (context) => get<ScheduleBloc>(),
            child: get<SchedulePage>());
      case 2:
        return get<FeedbackPage>();
      default:
        return getWithParam<InfoPage, List<String>>(
            ["Ошибка навигации", "Экран не создан?"]);
    }
  }

  BottomNavigationBar _createBottomNavigationBar(
          BuildContext context, AppState state) =>
      BottomNavigationBar(
        currentIndex: state.navIndex,
        selectedItemColor: Colors.red[800],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.radio),
            label: translate(StringKeys.home, context),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: translate(StringKeys.schedule, context),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.markunread_mailbox_outlined),
            label: translate(StringKeys.feedback, context),
          ),
        ],
        onTap: (navIndex) =>
            context.read<AppBloc>().add(AppNavPressedEvent(navIndex)),
      );

  FloatingActionButton _createFAB(BuildContext context, AppState state) =>
      FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppFabPressedEvent()),
        tooltip: 'Play / Stop',
        child: Icon(
            state.playingState ? Icons.stop_rounded : Icons.play_arrow_rounded),
      );
}
