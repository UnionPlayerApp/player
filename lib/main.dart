import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:union_player_app/di/di.dart';
import 'package:union_player_app/screen_init/init_page.dart';
import 'package:union_player_app/utils/app_logger.dart';

void main() {
  startKoin((app) {
    app.printLogger(level: Level.debug);
    app.module(appModule);
  });
  final _logger = AppLogger();
  _logger.logDebug("main()");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(WillPopScope(
      child: InitPage(),
      onWillPop: () async {
        _logger.logDebug("onWillPop()");
        MoveToBackground.moveTaskToBack();
        return false;
      }));
}
