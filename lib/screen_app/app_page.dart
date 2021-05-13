import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
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

  Expanded _buttonAppBar(BuildContext context, AppState state, int itemTab, IconData iconTab, StringKeys nameTab ) {
    return Expanded(
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        minWidth: 0,
        onPressed: () {
          context.read<AppBloc>().add(AppNavEvent(itemTab));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconTab,
              color: state.navIndex == itemTab ? Colors.red[800] : Colors.grey,
            ),
            Text(
              translate(nameTab, context),
              style: TextStyle(
                color: state.navIndex == itemTab ? Colors.red[800] : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
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
    actions: _createActions(context, state),
  );

  Widget _createTitle(BuildContext context, AppState state) {
    String data = state.title ?? translate(StringKeys.loading_error, context);
    return Text(data);
  }

  List<Widget>? _createActions(BuildContext context, AppState state){
    List <Widget>? actions;
    switch (state.navIndex) {
      case 2:
        actions =  [
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

  FloatingActionButton _createFAB(BuildContext context, AppState state) =>
      FloatingActionButton(
        onPressed: () => context.read<AppBloc>().add(AppFabEvent()),
        tooltip: 'Play / Stop',
        child: Icon(
            state.playingState ? Icons.stop_rounded : Icons.play_arrow_rounded),
      );
}
