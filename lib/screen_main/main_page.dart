import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/app//my_app_bar.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  IconData _appBarIcon =  Icons.play_arrow_rounded;

  void _onButtonAppBarTapped(){}

  Text createStateRow(BuildContext context, String stateStr) => Text(
        stateStr,
        style: Theme.of(context).textTheme.bodyText2,
      );

  FloatingActionButton createFAB(
          BuildContext context, MainState mainState, MainBloc mainBloc) =>
      FloatingActionButton(
        onPressed: () => mainBloc.add(PlayPauseFabPressed()),
        tooltip: 'Play / Stop',
        child: Icon(mainState.iconData),
      );

  Widget createWidget(BuildContext context, MainState mainState) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          createStateRow(context, mainState.stateStr01),
          createStateRow(context, mainState.stateStr02)
        ],
      );

  @override
  Widget build(BuildContext context) {
    final mainBloc = get<MainBloc>();
    return Scaffold(
        // appBar: createAppBar(),
        appBar: MyAppBar(_onButtonAppBarTapped, _appBarIcon),
        body: Center(
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, mainState) => createWidget(context, mainState),
            bloc: mainBloc,
          ),
        ),
        floatingActionButton: BlocBuilder<MainBloc, MainState>(
          builder: (context, mainState) =>
              createFAB(context, mainState, mainBloc),
          bloc: mainBloc,
        ));
  }
}
