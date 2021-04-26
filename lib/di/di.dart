import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/navigation/bottom_navigation_bloc.dart';
import 'package:union_player_app/navigation/bottom_navigation_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/info_page.dart';
import 'package:union_player_app/utils/loading_page.dart';

final appModule = Module()
  ..single((scope) => AudioPlayer())
  ..single((scope) => AppLogger())
  ..single((scope) => BottomNavigationBloc())
  ..single((scope) => BottomNavigationPage())
  ..single((scope) => MainBloc(scope.get(), scope.get()))
  ..single((scope) => MainPage())
  ..factoryWithParam((scope, String title) => LoadingPage(title: title))
  ..factoryWithParam((scope, List<String> strings) => InfoPage(strings: strings));
