import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/info_page.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';

class AppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _createAppBar(),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) =>
            _createPage(context, state),
      ),
      bottomNavigationBar: BlocBuilder<AppBloc, AppState>(
          builder: (BuildContext context, AppState state) =>
              _createBottomNavigationBar(context, state)),
      floatingActionButton: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => createFAB(context, state),
        bloc: get<AppBloc>(),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  AppBar _createAppBar() => AppBar(
        // backgroundColor: Colors.white,
        title: BlocBuilder<AppBloc, AppState>(
          builder: (BuildContext context, AppState state) =>
              _createTitle(context, state),
        ),
        leading: Container(
            padding: EdgeInsets.all(10.0),
            child: Image.asset(APP_BAR_LOGO_IMAGE, fit: BoxFit.fill)),
      );

  Widget _createTitle(BuildContext context, AppState state) => Text(
        "Выбран пункт ${state.navIndex}",
      );

  Widget _createPage(BuildContext context, AppState state) {
    switch (state.navIndex) {
      case 0:
        return BlocProvider(
            create: (context) => get<MainBloc>(), child: get<MainPage>());
      case 1:
        return get<SchedulePage>();
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings_rounded),
          //   label: translate(StringKeys.settings, context),
          // ),
        ],
        onTap: (navIndex) =>
            context.read<AppBloc>().add(AppNavPressedEvent(navIndex)),
      );

  FloatingActionButton createFAB(BuildContext context, AppState state) =>
      FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppFabPressedEvent()),
        tooltip: 'Play / Stop',
        child: Icon(
            state.isPlaying ? Icons.play_arrow_rounded : Icons.stop_rounded),
      );
}
