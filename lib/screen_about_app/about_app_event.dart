import 'dart:ui';

import 'package:union_player_app/screen_about_app/developer_model.dart';

abstract class AboutAppEvent {
  const AboutAppEvent();
}

class AboutAppInitEvent extends AboutAppEvent {
  final Locale locale;

  const AboutAppInitEvent({required this.locale});
}

abstract class AboutAppContactEvent extends AboutAppEvent {
  final DeveloperModel developerModel;

  const AboutAppContactEvent({required this.developerModel});
}

class AboutAppEmailEvent extends AboutAppContactEvent {
  const AboutAppEmailEvent({required DeveloperModel developerModel}) : super(developerModel: developerModel);
}

class AboutAppTelegramEvent extends AboutAppContactEvent {
  const AboutAppTelegramEvent({required DeveloperModel developerModel}) : super(developerModel: developerModel);
}

class AboutAppWhatsappEvent extends AboutAppContactEvent {
  const AboutAppWhatsappEvent({required DeveloperModel developerModel}) : super(developerModel: developerModel);
}
