import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:logger/logger.dart' as LoggerLib;

final appModule = Module()
  ..single((s) => AudioPlayer())
  ..single((s) => LoggerLib.Logger());
