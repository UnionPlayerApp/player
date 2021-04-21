import 'package:flutter/material.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_event.dart';
import 'package:union_player_app/screen_main/main_state.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  AppBar createAppBar() => AppBar(title: Text("Main screen"));

  Text createStateRow(BuildContext context, String stateStr) => Text(
        stateStr,
        style: Theme.of(context).textTheme.bodyText2,
      );

  FloatingActionButton createFAB(
          BuildContext context, MainState mainState, MainBloc mainBloc) =>
      FloatingActionButton(
        onPressed: () => mainBloc.add(PlayPauseFabPressed()),
        tooltip: 'Play / Pause',
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
    final mainBloc = MainBloc(get(), get());
    return Scaffold(
        appBar: createAppBar(),
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
