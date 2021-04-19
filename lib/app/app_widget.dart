import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Union Radio Player',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: BlocProvider(
          create: (context) => MainBloc(),
          child: MainPage(title: 'Union Player Home Page')
      ),
    );
  }
}
