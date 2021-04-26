import 'package:flutter/material.dart';
import 'package:koin/koin.dart';
import 'package:union_player_app/app/app_page.dart';
import 'package:union_player_app/di/di.dart';

void main() {
  startKoin((app) {
    app.printLogger(level: Level.debug);
    app.module(appModule);
  });
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppPage());
}