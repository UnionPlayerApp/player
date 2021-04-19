import 'package:flutter/material.dart';

import 'packahghge:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';

void main() {
  startKoin((app) {
    app.module(appModule);
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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