import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  late final MainBloc mainBloc;

  AppBar createAppBar() =>
      AppBar(
        title: Text("Main screen"),
      );

  Text createStateRow(BuildContext context, String stateStr) =>
      Text(
        stateStr,
        style: Theme
            .of(context)
            .textTheme
            .bodyText2,
      );

  FloatingActionButton createFAB(IconData iconData) =>
      FloatingActionButton(
        onPressed: () => mainBloc.add(PlayPauseFabPressed()),
        tooltip: 'Play / Pause',
        child: Icon(iconData),
      );

  @override
  Widget build(BuildContext context) {
    mainBloc = BlocProvider.of<MainBloc>(context);
    return Scaffold(
        appBar: createAppBar(),
        body: Center(
          child: BlocBuilder<MainBloc, MainState>(
            builder: (_, mainState) =>
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    createStateRow(context, mainState.stateStr01),
                    createStateRow(context, mainState.stateStr02)
                  ],
                ),
          ),
        ),
        floatingActionButton: BlocBuilder<MainBloc, MainState>(
            buildWhen: (oldState, newState) =>
            oldState.stateStr01 != newState.stateStr01,
            builder: (_, mainState) =>
                createFAB(mainState.iconData)
        )
    );
  }
}