import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/blocs/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:union_player_app/ui/app_screen.dart';
import 'package:union_player_app/ui/pages/screen_main/main_bloc.dart';
import 'package:union_player_app/ui/pages/screen_main/main_page.dart';
import 'package:union_player_app/utils/AppLogger.dart';

final appModule = Module()
  ..single((scope) => AudioPlayer())
  ..single((scope) => AppLogger())
  ..single((scope) => MainBloc(scope.get(), scope.get()))
  ..single((scope) => BottomNavigationBloc())
  ..single((scope) => AppScreen())
  ..single((scope) => MainPage());
