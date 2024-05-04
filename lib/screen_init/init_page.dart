import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/core/extensions.dart';
import 'package:union_player_app/common/enums/language_type.dart';
import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:union_player_app/common/localizations/string_translation.dart';
import 'package:union_player_app/common/widgets/info_page.dart';
import 'package:union_player_app/common/widgets/progress_page.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/providers/shared_preferences_manager.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';

import '../common/enums/start_playing_type.dart';
import '../common/enums/string_keys.dart';
import '../firebase_options.dart';

class InitPage extends StatefulWidget {
  final PackageInfo _packageInfo;

  const InitPage({super.key, required PackageInfo packageInfo})
      : _packageInfo = packageInfo;

  @override
  InitPageState createState() => InitPageState();
}

class InitPageState extends State<InitPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late final _spManager = GetIt.I.get<SPManager>();
  late final _systemData = GetIt.I.get<SystemData>();
  late final Future<bool> _initAppFuture;
  late final UserCredential _userCredential;
  var _initStage = "initial stage";

  @override
  void initState() {
    super.initState();
    _initAppFuture = _initApp();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (_spManager.readThemeMode() == ThemeMode.system) {
      final systemThemeMode = View.of(context).platformDispatcher.platformBrightness.toThemeMode;
      Get.changeThemeMode(systemThemeMode);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      initialData: defaultIsPlaying,
      future: _initAppFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) => _createHomePage(snapshot),
    );
  }

  Future<bool> _initApp() => _initFirebase()
      .then((_) => _initLogger())
      .then((_) => _initLocale())
      .then((_) => _initTheme())
      .then((_) => _initAppTrackingTransparency())
      .then((_) => _initSystemData())
      .then((_) => _initPlayer())
      .then((isPlaying) => _logAppStatus(isPlaying))
      .catchError((error) => _handleError(error));

  FutureOr<bool> _handleError(dynamic error) {
    const msg = "App initialisation error";
    debugPrint("$msg: $_initStage: $error");
    throw Exception([msg, error]);
  }

  Future _initFirebase() async {
    _initStage = "Firebase init stage";
    debugPrint(_initStage);
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebaseAppCheck.instance.activate();
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(kReleaseMode);
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
      _userCredential = await FirebaseAuth.instance.signInAnonymously();
    } catch (error) {
      throw Exception("Firebase initialize error: $error");
    }
    debugPrint("Firebase initializing is successful");
  }

  Future<bool> _logAppStatus(bool isPlaying) async {
    _initStage = "Log App Status init stage";
    debugPrint(_initStage);
    // TODO: need to fix
    // final appCheckToken = await FirebaseAppCheck.instance.getToken();
    const appCheckToken = "temporary unsupported";
    final authIsAnonymous = _userCredential.user?.isAnonymous == null
        ? "null"
        : _userCredential.user!.isAnonymous
            ? "true"
            : "false";
    final params = {
      "package_info_version": widget._packageInfo.version,
      "package_info_build_number": widget._packageInfo.buildNumber,
      "package_info_build_signature": widget._packageInfo.buildSignature,
      "package_info_package_name": widget._packageInfo.packageName,
      "platform_operating_system": Platform.operatingSystem,
      "platform_operating_system_version": Platform.operatingSystemVersion,
      "platform_version": Platform.version,
      "platform_locale_Name": Platform.localeName,
      "app_check_token": appCheckToken,
      "auth_is_anonymous": authIsAnonymous,
      "auth_refresh_token": _userCredential.user?.refreshToken ?? "null",
      "auth_uid": _userCredential.user?.uid ?? "null",
    };
    params.forEach((key, value) => debugPrint("key: $key, value type: ${value.runtimeType}, value: $value"));
    FirebaseAnalytics.instance.logEvent(name: gaAppStatus, parameters: params);
    debugPrint("App initialize success, app params = $params");
    return isPlaying;
  }

  FutureOr<void> _initLogger() {
    _initStage = "Logger init stage";
    debugPrint(_initStage);
    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) => FirebaseCrashlytics.instance.log(message ?? emptyLogMessage);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    } else {
      debugPrint = (String? message, {int? wrapWidth}) => log(message ?? emptyLogMessage, name: logName);
    }
  }

  Future<void> _initLocale() async {
    _initStage = "Locale init stage";
    debugPrint(_initStage);
    return Get.updateLocale(_spManager.readLanguageType().locale);
  }

  Future<void> _initTheme() async {
    _initStage = "Theme init stage";
    debugPrint(_initStage);
    return Get.changeThemeMode(_spManager.readThemeMode());
  }

  Future _initAppTrackingTransparency() async {
    _initStage = "App Tracking Transparency init stage";
    debugPrint(_initStage);
    try {
      var status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await _showAppTrackingInfoDialog();
        // Wait for dialog popping animation
        await Future.delayed(const Duration(milliseconds: 200));
        status = await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint("App tracking transparency status = $status");
      }
    } on PlatformException {
      debugPrint("App tracking transparency init error: platform exception");
    } catch (error) {
      debugPrint("App tracking transparency init error: $error");
    }
  }

  Future<void> _showAppTrackingInfoDialog() async {
    final title = Text(translate(StringKeys.trackingDialogTitle, context), textAlign: TextAlign.center);
    final content = Text(translate(StringKeys.trackingDialogText, context), textAlign: TextAlign.center);
    final button = TextButton(
      child: Text(translate(StringKeys.trackingDialogButton, context)),
      onPressed: () => Navigator.pop(context),
    );
    final dialogWidget = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: title,
      content: content,
      actions: [button],
    );
    return showDialog<void>(
      context: context,
      builder: (context) => dialogWidget,
    );
  }

  Future _initSystemData() async {
    _initStage = "System Data init stage";
    debugPrint(_initStage);

    late final CollectionReference collection;

    try {
      collection = FirebaseFirestore.instance.collection('system_data');
    } catch (error) {
      throw Exception("System data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("email_data").get();
      _systemData.setEmailData(doc);
    } catch (error) {
      throw Exception("Email data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("xml_data").get();
      _systemData.setXmlData(doc);
    } catch (error) {
      throw Exception("XML data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("about_data").get();
      _systemData.setAboutData(doc);
    } catch (error) {
      throw Exception("About data read error: $error");
    }

    try {
      DocumentSnapshot doc = await collection.doc("stream_data").get();
      _systemData.setStreamData(doc);
    } catch (error) {
      throw Exception("Stream data read error: $error");
    }

    debugPrint("System data initialize success");
  }

  Future<bool> _initPlayer() async {
    _initStage = "Player init stage";
    debugPrint(_initStage);

    _systemData.playerData.appTitle = translate(StringKeys.appTitle, context);

    final soundQualityType = _spManager.readSoundQualityType();
    final startPlayingType = _spManager.readStartPlayingType();

    late final bool isPlaying;

    switch (startPlayingType) {
      case StartPlayingType.start:
        isPlaying = true;
        break;
      case StartPlayingType.stop:
        isPlaying = false;
        break;
      case StartPlayingType.last:
        isPlaying = _spManager.readIsPlaying();
        break;
    }

    final playerHandler = await AudioService.init(
      builder: () => GetIt.I.get<AudioHandler>(),
      config: const AudioServiceConfig(
        androidNotificationChannelName: audioNotificationChannelName,
        androidNotificationIcon: audioNotificationIcon,
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
        notificationColor: Colors.lightGreenAccent,
      ),
    );

    await playerHandler.customAction(actionStart, _createPlayerTaskParams(soundQualityType, isPlaying));

    debugPrint("Player initialize success");

    return isPlaying;
  }

  Map<String, dynamic> _createPlayerTaskParams(SoundQualityType soundQualityType, bool isPlaying) {
    final Map<String, dynamic> params = {
      keyAppTitle: _systemData.playerData.appTitle,
      keyUrlStreamLow: _systemData.streamData.streamLow,
      keyUrlStreamMedium: _systemData.streamData.streamMedium,
      keyUrlStreamHigh: _systemData.streamData.streamHigh,
      keyUrlSchedule: _systemData.xmlData.url,
      keySoundQuality: soundQualityType.integer,
      keyIsPlaying: isPlaying,
    };
    return params;
  }

  Widget _createHomePage(AsyncSnapshot<dynamic> snapshot) {
    return _progressPage();
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        final bool isPlaying = snapshot.data;
        return _createAppPage(isPlaying);
      }
      if (snapshot.hasError) {
        final List<String> infoPageStrings = _createInfoPageStrings();
        return GetIt.I.get<InfoPage>(param1: infoPageStrings);
      }
    }
    return _progressPage();
  }

  List<String> _createInfoPageStrings() => ([
        translate(StringKeys.appIsNotInit1, context),
        translate(StringKeys.appIsNotInit2, context),
        translate(StringKeys.appIsNotInit3, context),
        translate(StringKeys.appIsNotInit4, context),
        translate(StringKeys.appIsNotInit5, context),
      ]);

  Widget _createAppPage(bool isPlaying) => BlocProvider(
        create: (_) => GetIt.I.get<AppBloc>(param1: isPlaying),
        child: GetIt.I.get<AppPage>(),
      );

  Widget _progressPage() {
    final version = "${widget._packageInfo.version} (${widget._packageInfo.buildNumber})";
    return GetIt.I.get<ProgressPage>(param1: version);
  }
}
