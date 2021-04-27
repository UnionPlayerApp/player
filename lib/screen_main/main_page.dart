import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_state.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) => _createWidget(context, state),
          bloc: get<MainBloc>(),
        ),
      );

  Widget _createWidget(BuildContext context, MainState mainState) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      _createStateRow(context, mainState.stateStr01),
      _createStateRow(context, mainState.stateStr02)
    ],
  );

  Text _createStateRow(BuildContext context, String stateStr) => Text(
    stateStr,
    style: Theme.of(context).textTheme.bodyText2,
  );
}
