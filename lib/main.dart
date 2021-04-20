import 'package:flutter/material.dart';
import 'package:union_player_app/app/app_widget.dart';
import 'package:koin/koin.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:koin/instance_factory.dart';
import 'package:union_player_app/di/app_module.dart';

void main() {
  startKoin((app) {
    app.printLogger(level: Level.debug);
    app.module(appModule);
  });

  KoinContextHandler.get();

  runApp(AppWidget());
}