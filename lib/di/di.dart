import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/player/app_player_handler.dart';
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
import 'package:union_player_app/utils/widgets/progress_page.dart';
import 'package:uuid/uuid.dart';

import '../player/app_player.dart';

final appModule = Module()
// pages and blocs
  ..factoryWithParam((s, List<String> params) => InfoPage(params: params))
  ..factoryWithParam((s, List<String> params) => ProgressPage(params: params))
  ..singleWithParam((s, bool isPlaying) => AppBloc(s.get(), isPlaying))
  ..single((s) => AppPage())
  ..single((s) => FeedbackBloc(s.get()))
  ..single((s) => FeedbackPage(s.get()))
  ..single((s) => MainBloc(s.get()))
  ..single((s) => MainPage())
  ..single((s) => ScheduleBloc(audioHandler: s.get()))
  ..single((s) => SchedulePage())
  ..single((s) => SettingsBloc())
  ..single((s) => SettingsPage())
// system classes
  ..single<AppLogger>((s) => AppLogger())
  ..single<AudioPlayer>((s) => AppPlayer())
  ..single<AudioHandler>((s) => AppPlayerHandler(
        player: s.get(),
        schedule: s.get(),
        random: s.get(),
        uuid: s.get(),
      ))
  ..single<IScheduleRepository>((s) => ScheduleRepositoryImpl())
  ..single<SystemData>((s) => SystemData())
  ..factory<Uuid>((s) => Uuid())
  ..factory<Random>((s) => Random());
