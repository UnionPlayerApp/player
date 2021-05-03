import 'package:just_audio/just_audio.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/repository/schedule_repository_impl.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/screen_feedback/feedback_page.dart';
import 'package:union_player_app/screen_main/main_bloc.dart';
import 'package:union_player_app/screen_main/main_page.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/info_page.dart';
import 'package:union_player_app/utils/loading_page.dart';

final appModule = Module()
  ..single((scope) => AudioPlayer())
  ..single((scope) => AppLogger())
  ..single((scope) => AppBloc(scope.get()))
  ..single((scope) => AppPage())
  ..single((scope) => MainBloc(scope.get(), scope.get()))
  ..single((scope) => MainPage())
  ..single((scope) => FeedbackPage())
  ..single((scope) => ScheduleRepositoryImpl())
  ..single((scope) => ScheduleBloc(scope.get<ScheduleRepositoryImpl>()))
  ..single((scope) => SchedulePage())
  ..factoryWithParam((scope, String title) => LoadingPage(title: title))
  ..factoryWithParam((scope, List<String> strings) => InfoPage(strings: strings));
