import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/utils/AppLogger.dart';

final appModule = Module()
  ..single((scope) => AudioPlayer())
  ..single((scope) => AppLogger());
