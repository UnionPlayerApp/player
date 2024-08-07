import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../screen_about_app/about_app_bloc.dart';
import '../screen_about_app/about_app_page.dart';
import '../screen_about_radio/about_radio_bloc.dart';
import '../screen_about_radio/about_radio_page.dart';
import '../screen_init/init_page.dart';
import '../screen_listen/listen_bloc.dart';
import '../screen_listen/listen_page.dart';
import '../screen_schedule/schedule_bloc.dart';
import '../screen_schedule/schedule_page.dart';
import '../screen_settings/settings_bloc.dart';
import '../screen_settings/settings_page.dart';

class Routes {
  static const aboutApp = '/about_app';
  static const aboutRadio = '/about_radio';
  static const initialRoute = "/";
  static const listen = '/listen';
  static const schedule = '/schedule';
  static const settings = '/settings';

  Map<String, WidgetBuilder> getRoutes() {
    return {
      aboutApp: (_) => _blocPage<AboutAppPage, AboutAppBloc>(),
      aboutRadio: (_) => _blocPage<AboutRadioPage, AboutRadioBloc>(),
      listen: (_) => _blocPage<ListenPage, ListenBloc>(),
      schedule: (_) => _blocPage<SchedulePage, ScheduleBloc>(),
      settings: (_) => _blocPage<SettingsPage, SettingsBloc>(),
    };
  }

  Widget initialPage({required PackageInfo packageInfo}) => _simplePage<InitPage>(param: packageInfo);

  Widget page(BuildContext context, {required String routeName}) {
    final builder = getRoutes()[routeName];
    return builder == null ? Container() : builder.call(context);
  }

  Widget _simplePage<P extends Widget>({dynamic param}) {
    return GetIt.I.get<P>(param1: param);
  }

  Widget _blocPage<P extends Widget, B extends Bloc>() => BlocProvider(
        create: (_) => GetIt.I.get<B>(),
        child: GetIt.I.get<P>(),
      );
}
