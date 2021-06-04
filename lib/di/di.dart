import 'package:koin/koin.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
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

final appModule = Module()
  ..factoryWithParam((scope, List<String> strings) => InfoPage(strings: strings))
  ..factoryWithParam((scope, String title) => ProgressPage(title: title))
  ..single((scope) => AppBloc(scope.get(), scope.get()))
  ..single((scope) => AppLogger())
  ..single((scope) => AppPage())
  ..single((scope) => FeedbackBloc(scope.get(), scope.get()))
  ..single((scope) => FeedbackPage(scope.get()))
  ..single((scope) => MainBloc())
  ..single((scope) => MainPage())
  ..single((scope) => ScheduleBloc(scope.get()))
  ..single((scope) => SchedulePage())
  ..single((scope) => SettingsBloc())
  ..single((scope) => SettingsPage())
  ..single((scope) => SystemData());
