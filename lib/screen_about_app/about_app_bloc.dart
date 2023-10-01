import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/enums/string_keys.dart';
import 'about_app_event.dart';
import 'about_app_state.dart';

class AboutAppBloc extends Bloc<AboutAppEvent, AboutAppState> {
  final SystemData _systemData;
  final PackageInfo _packageInfo;

  AboutAppBloc(this._packageInfo, this._systemData) : super(const AboutAppLoadingState()) {
    on<AboutAppInitEvent>(_onInitial);
    on<AboutAppEmailEvent>(_onEmail);
    on<AboutAppTelegramEvent>(_onTelegram);
    on<AboutAppWhatsappEvent>(_onWhatsapp);
  }

  FutureOr<void> _onInitial(AboutAppInitEvent event, Emitter<AboutAppState> emitter) async {
    final newState = AboutAppLoadedState(
      version: _packageInfo.version,
      buildNumber: _packageInfo.buildNumber,
      developers: await _systemData.developers(event.locale),
    );
    emitter(newState);
  }

  FutureOr<void> _onEmail(AboutAppEmailEvent event, Emitter<AboutAppState> emitter) async {
    final newState = await _onContact(url: "mailto:${event.developerModel.email}");
    if (newState != null) {
      emitter(newState);
    }
  }

  FutureOr<void> _onTelegram(AboutAppTelegramEvent event, Emitter<AboutAppState> emitter) async {
    final newState = await _onContact(url: 'https://t.me/${event.developerModel.telegram}');
    if (newState != null) {
      emitter(newState);
    }
  }

  FutureOr<void> _onWhatsapp(AboutAppWhatsappEvent event, Emitter<AboutAppState> emitter) async {
    final newState = await _onContact(url: "whatsapp://send?phone=${event.developerModel.whatsapp}");
    if (newState != null) {
      emitter(newState);
    }
  }

  Future<AboutAppState?> _onContact({required String url}) async {
    assert(state is AboutAppLoadedState, "The method _onContact() should be invoke for AboutAppLoadedState only");

    final currentState = state as AboutAppLoadedState;

    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return null;
    } catch (error) {
      return error is PlatformException && error.code == "ACTIVITY_NOT_FOUND"
          ? currentState.copyWith(toastKey: StringKeys.contactAppNotFound)
          : currentState.copyWith(toastKey: StringKeys.contactAppLaunchError, toastParam: error.toString());
    }
  }
}
