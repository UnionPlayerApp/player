import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:koin_bloc/koin_bloc.dart';
import 'package:logger/logger.dart' as LoggerLib;
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';

final appModule = Module()
  ..single((scope) => AudioPlayer())
  ..single((scope) => LoggerLib.Logger())
  ..single((scope) => MainPage());
