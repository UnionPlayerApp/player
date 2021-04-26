import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:union_player_app/schedule_screen/schedule_screen.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';

import 'feedback_screen/feedback_screen.dart';

void main() {
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