import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/screen_settings/settings_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/info_page.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) =>
            Scaffold(
              appBar: _createAppBar(context, state),
              body: _createPage(context, state),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: _createFAB(context, state),
              bottomNavigationBar: _createBottomNavigationBar(context, state),
            ));
    //   //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    // );
  }

  AppBar _createAppBar(BuildContext context, AppState state) =>
      AppBar(
        // backgroundColor: Colors.white,
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
            create: (context) => get<MainBloc>(), child: get<MainPage>());
      case 1:
        return get<SchedulePage>();
      case 2:
        return get<FeedbackPage>();
      case 3:
        return get<SettingsPage>();
      default:
        return getWithParam<InfoPage, List<String>>(
            ["Ошибка навигации", "Экран не создан?"]);
    }
  }

  BottomNavigationBar _createBottomNavigationBar(BuildContext context,
      AppState state) =>
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
        // SizedBox(width: 40),
          BottomNavigationBarItem(
            icon: Icon(Icons.markunread_mailbox_outlined),
            label: translate(StringKeys.feedback, context),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: translate(StringKeys.settings, context),
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
          elevation: 2.0
      );
}
