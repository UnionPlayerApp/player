import 'dart:math';

import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:logger/logger.dart' as Logger;
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/player/audio_player_handler.dart';
import 'package:union_player_app/repository/schedule_repository_impl.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/screen_feedback/feedback_bloc.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/widgets/info_page.dart';
import 'package:union_player_app/utils/widgets/loading_page.dart';
import 'package:uuid/uuid.dart';

import '../player/app_player.dart';

final appModule = Module()
  // pages and blocs
  ..factoryWithParam((s, List<String> strings) => InfoPage(strings: strings))
  ..factoryWithParam((s, String title) => ProgressPage(title: title))
  ..singleWithParam((s, bool isPlaying) => AppBloc(isPlaying))
  ..single((s) => AppPage())
  ..single((s) => FeedbackBloc(s.get(), s.get()))
  ..single((s) => FeedbackPage(s.get()))
  ..single((s) => MainBloc())
  ..single((s) => MainPage())
  ..single((s) => ScheduleBloc())
  ..single((s) => SchedulePage())
  ..single((s) => SettingsBloc())
  ..single((s) => SettingsPage())
  // system classes
  ..single<Logger.Logger>((s) => AppLogger())
  ..single<AudioPlayer>((s) => AppPlayer())
  ..single<AppPlayerHandler>(
    (s) => AppPlayerHandler(
      player: s.get(),
      schedule: s.get(),
      random: s.get(),
      uuid: s.get(),
    ),
  )
  ..single<IScheduleRepository>((s) => ScheduleRepositoryImpl())
  ..single<SystemData>((s) => SystemData())
  ..factory<Uuid>((s) => Uuid())
  ..factory<Random>((s) => Random());
