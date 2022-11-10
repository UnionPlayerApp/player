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
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/extensions.dart';
import 'package:union_player_app/utils/core/shared_preferences.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/widgets/info_page.dart';
import 'package:union_player_app/utils/widgets/progress_page.dart';

import '../firebase_options.dart';
import '../utils/core/locale_utils.dart';

class InitPage extends StatefulWidget {
  final PackageInfo _packageInfo;

  const InitPage({Key? key, required PackageInfo packageInfo})
      : _packageInfo = packageInfo,
        super(key: key);

  @override
  InitPageState createState() => InitPageState();
}

class InitPageState extends State<InitPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late final SystemData _systemData;
  late final Future<bool> _initAppFuture;
  late final UserCredential _userCredential;
  var _initStage = "initial stage";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _systemData = get<SystemData>();
    _initAppFuture = _initApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    get<AudioHandler>().stop();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    SpManager.readThemeMode().then((settings) {
      if (settings == ThemeMode.system) {
        final themeMode = SchedulerBinding.instance.window.platformBrightness.toThemeMode;
        Get.changeThemeMode(themeMode);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      initialData: defaultIsPlaying,
      future: _initAppFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        final homePage = _createHomePage(snapshot);
        return _wrapScreenUtilInit(homePage);
      },
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
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await FirebasePerformance.instance.setPerformanceCollectionEnabled(kReleaseMode);
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(kReleaseMode);
      _userCredential = await FirebaseAuth.instance.signInAnonymously();
      await FirebaseAppCheck.instance.activate();
    } catch (error) {
      throw Exception("Firebase initialize error: $error");
    }
  }

  Future<bool> _logAppStatus(bool isPlaying) async {
    _initStage = "Log App Status init stage";
    final appCheckToken = await FirebaseAppCheck.instance.getToken();
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
      "auth_is_anonymous": _userCredential.user?.isAnonymous ?? "null",
      "auth_refresh_token": _userCredential.user?.refreshToken ?? "null",
      "auth_uid": _userCredential.user?.uid ?? "null",
    };
    FirebaseAnalytics.instance.logEvent(name: gaAppStatus, parameters: params);
    debugPrint("App initialize success, app params = $params");
    return isPlaying;
  }

  FutureOr<void> _initLogger() {
    _initStage = "Logger init stage";
    if (kReleaseMode) {
      debugPrint = (String? message, {int? wrapWidth}) => FirebaseCrashlytics.instance.log(message ?? emptyLogMessage);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    } else {
      debugPrint = (String? message, {int? wrapWidth}) => log(message ?? emptyLogMessage, name: logName);
    }
  }

  Future<void> _initLocale() async {
    _initStage = "Locale init stage";
    final langId = await readIntFromSharedPreferences(keyLang) ?? defaultLangId;
    final newLocale = getLocaleById(langId);
    return Get.updateLocale(newLocale);
  }

  Future<void> _initTheme() async {
    _initStage = "Theme init stage";
    final themeId = await readIntFromSharedPreferences(keyTheme) ?? defaultThemeId;
    setIcAudioQuality(themeId);
  }

  Future _initAppTrackingTransparency() async {
    _initStage = "App Tracking Transparency init stage";
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

    debugPrint("Player initialize start");

    _systemData.playerData.appTitle = translate(StringKeys.appTitle, context);

    final SharedPreferences sp = await SharedPreferences.getInstance();

    final int audioQualityId = sp.getInt(keyAudioQuality) ?? defaultAudioQualityId;
    final int startPlayingId = sp.getInt(keyStartPlaying) ?? defaultStartPlayingId;

    late final bool isPlaying;
    switch (startPlayingId) {
      case startPlayingStart:
        isPlaying = true;
        break;
      case startPlayingStop:
        isPlaying = false;
        break;
      case startPlayingLast:
        isPlaying = sp.getBool(keyIsPlaying) ?? defaultIsPlaying;
        break;
      default:
        isPlaying = defaultIsPlaying;
        break;
    }

    final playerHandler = await AudioService.init(
      builder: () => get<AudioHandler>(),
      config: const AudioServiceConfig(
        androidNotificationChannelName: audioNotificationChannelName,
        androidNotificationIcon: audioNotificationIcon,
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
        notificationColor: Colors.lightGreenAccent,
      ),
    );

    await playerHandler.customAction(actionStart, _createPlayerTaskParams(audioQualityId, isPlaying));

    debugPrint("Player initialize success");

    return isPlaying;
  }

  Map<String, dynamic> _createPlayerTaskParams(int audioQualityId, bool isPlaying) {
    final Map<String, dynamic> params = {
      keyAppTitle: _systemData.playerData.appTitle,
      keyUrlStreamLow: _systemData.streamData.streamLow,
      keyUrlStreamMedium: _systemData.streamData.streamMedium,
      keyUrlStreamHigh: _systemData.streamData.streamHigh,
      keyUrlSchedule: _systemData.xmlData.url,
      keyAudioQuality: audioQualityId,
      keyIsPlaying: isPlaying,
    };
    return params;
  }

  Widget _createHomePage(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData) {
        final bool isPlaying = snapshot.data;
        return _createAppPage(isPlaying);
      }
      if (snapshot.hasError) {
        final List<String> infoPageStrings = _createInfoPageStrings();
        return getWithParam<InfoPage, List<String>>(infoPageStrings);
      }
    }
    return _progressPage();
  }

  Widget _wrapScreenUtilInit(Widget homePage) {
    return ScreenUtilInit(
      designSize: const Size(PROTOTYPE_DEVICE_WIDTH, PROTOTYPE_DEVICE_HEIGHT),
      builder: (_, __) => homePage,
    );
  }

  List<String> _createInfoPageStrings() => ([
        translate(StringKeys.appIsNotInit1, context),
        translate(StringKeys.appIsNotInit2, context),
        translate(StringKeys.appIsNotInit3, context),
        translate(StringKeys.appIsNotInit4, context),
        translate(StringKeys.appIsNotInit5, context),
      ]);

  Widget _createAppPage(bool isPlaying) => BlocProvider.value(
        value: getWithParam<AppBloc, bool>(isPlaying),
        child: get<AppPage>(),
      );

  Widget _progressPage() {
    final title = translate(StringKeys.appInitTitle, context);
    final version = "${widget._packageInfo.version} (${widget._packageInfo.buildNumber})";
    return getWithParam<ProgressPage, List<String>>([title, version]);
  }
}
