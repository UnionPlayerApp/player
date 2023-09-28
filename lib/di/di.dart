import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/player/app_player_handler.dart';
import 'package:union_player_app/repository/schedule_repository_impl.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/screen_about_radio/about_radio_bloc.dart';
import 'package:union_player_app/screen_about_radio/about_radio_page.dart';
import 'package:union_player_app/screen_init/init_page.dart';
import 'package:union_player_app/screen_schedule/schedule_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_page.dart';
import 'package:union_player_app/screen_settings/settings_bloc.dart';
import 'package:union_player_app/screen_settings/settings_page.dart';
import 'package:union_player_app/common/app_logger.dart';
import 'package:union_player_app/common/widgets/info_page.dart';
import 'package:union_player_app/common/widgets/progress_page.dart';
import 'package:uuid/uuid.dart';

import '../common/routes.dart';
import '../player/app_player.dart';
import '../providers/shared_preferences_manager.dart';
import '../screen_listen/listen_bloc.dart';
import '../screen_listen/listen_page.dart';

class BindingModule {
  static void providesTools() {
    GetIt.I.registerLazySingleton<AppLogger>(() => AppLogger());
    GetIt.I.registerLazySingleton<AudioHandler>(() => AppPlayerHandler(
          GetIt.I.get(),
          GetIt.I.get(),
          GetIt.I.get(),
          GetIt.I.get(),
        ));
    GetIt.I.registerLazySingleton<AudioPlayer>(() => AppPlayer());
    GetIt.I.registerLazySingleton<IScheduleRepository>(() => ScheduleRepositoryImpl());
    GetIt.I.registerLazySingleton<Random>(() => Random());
    GetIt.I.registerLazySingleton<Routes>(() => Routes());
    GetIt.I.registerLazySingleton<SystemData>(() => SystemData());
    GetIt.I.registerLazySingleton<Uuid>(() => const Uuid());
    GetIt.I.registerLazySingletonAsync(() => SPManager.createInstance());
  }

  static void providesPages() {
    GetIt.I.registerFactory(() => AppPage());
    GetIt.I.registerFactory(() => AboutRadioPage());
    GetIt.I.registerFactory(() => ListenPage());
    GetIt.I.registerFactory(() => SchedulePage());
    GetIt.I.registerFactory(() => SettingsPage());
    GetIt.I.registerFactoryParam<InfoPage, List<String>, void>((params, _) => InfoPage(params: params));
    GetIt.I.registerFactoryParam<InitPage, PackageInfo, void>((packageInfo, _) => InitPage(packageInfo: packageInfo));
    GetIt.I.registerFactoryParam<ProgressPage, String, void>((appVersion, _) => ProgressPage(version: appVersion));
  }

  static void providesBlocs() {
    GetIt.I.registerFactoryParam<AppBloc, bool, void>((isPlaying, _) => AppBloc(GetIt.I.get(), isPlaying));
    GetIt.I.registerFactory(() => AboutRadioBloc(GetIt.I.get()));
    GetIt.I.registerFactory(() => ListenBloc(GetIt.I.get(), GetIt.I.get()));
    GetIt.I.registerFactory(() => ScheduleBloc(audioHandler: GetIt.I.get()));
    GetIt.I.registerFactory(() => SettingsBloc(GetIt.I.get(), GetIt.I.get(), GetIt.I.get()));
  }

  static Future<void> initAsyncSingletons() {
    return Future.wait([
      GetIt.I.getAsync<SPManager>(),
    ]).then((_) => null);
  }
}
