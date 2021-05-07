import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/screen_settings/settings_page.dart';
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
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: _createBottomNavigationBar(context, state),
          ),
        )
    );
  }

  BottomAppBar _createBottomNavigationBar(
      BuildContext context, AppState state) =>
      BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Left Tab Bar Icons
              Expanded(
                flex: 1,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      // maxWidth: 100,
                      onPressed: () {
                          context.read<AppBloc>().add(AppNavPressedEvent(0));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.radio,
                            color: state.navIndex == 0 ? Colors.red[800] : Colors.grey,
                          ),
                          Text(
                            translate(StringKeys.home, context),
                            style: TextStyle(
                              color: state.navIndex == 0 ? Colors.red[800] : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                          context.read<AppBloc>().add(AppNavPressedEvent(1));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt,
                            color: state.navIndex == 1 ? Colors.red[800] : Colors.grey,
                          ),
                          Text(
                            translate(StringKeys.schedule, context),
                            style: TextStyle(
                              color: state.navIndex == 1 ? Colors.red[800] : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              //Right Tab Bar Icons
              Expanded(
                flex: 1,
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                          context.read<AppBloc>().add(AppNavPressedEvent(2));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.markunread_mailbox_outlined,
                            color: state.navIndex == 2 ? Colors.red[800] : Colors.grey,
                          ),
                          Text(
                            translate(StringKeys.feedback, context),
                            style: TextStyle(
                              color: state.navIndex == 2 ? Colors.red[800] : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                          context.read<AppBloc>().add(AppNavPressedEvent(3));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.settings_rounded,
                            color: state.navIndex == 3 ? Colors.red[800] : Colors.grey,
                          ),
                          Text(
                            translate(StringKeys.settings, context),
                            style: TextStyle(
                              color: state.navIndex == 3 ? Colors.red[800] : Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

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
      case 3:
        data = "Settings page";
        break;
    }
    return Text(data);
  }

  Widget _createPage(BuildContext context, AppState state) {
    switch (state.navIndex) {
      case 0:
        return BlocProvider(
            create: (context) => get<MainBloc>(),
            child: get<MainPage>());
      case 1:
        return BlocProvider(
            create: (context) => get<ScheduleBloc>(),
            child: get<SchedulePage>());
      case 2:
        return get<FeedbackPage>();
      case 3:
        return get<SettingsPage>();
      default:
        return getWithParam<InfoPage, List<String>>(
            ["Ошибка навигации", "Экран не создан?"]);
    }
  }

  FloatingActionButton _createFAB(BuildContext context, AppState state) =>
      FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppFabPressedEvent()),
        tooltip: 'Play / Stop',
        child: Icon(
            state.playingState ? Icons.stop_rounded : Icons.play_arrow_rounded),
      );
}
