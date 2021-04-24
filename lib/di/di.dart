import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/utils/AppLogger.dart';

final appModule = Module()
  ..single((scope) => AudioPlayer())
  ..single((scope) => AppLogger())
  ..single((scope) => MainBloc(scope.get(), scope.get()))
  ..single((scope) => MainPage());
