import 'dart:async';
import 'dart:developer';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/player/audio_player_handler.dart';
import 'package:union_player_app/player/player_task.dart';
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
import 'package:union_player_app/utils/localizations/string_translation.dart';
import 'package:union_player_app/utils/widgets/info_page.dart';
import 'package:union_player_app/utils/widgets/loading_page.dart';

class InitPage extends StatefulWidget {
  InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> with AutomaticKeepAliveClientMixin {
  late final SystemData _systemData;
  late Future<bool> _initAppFuture;

  @override
  void initState() {
    super.initState();

    _systemData = get<SystemData>();
    _initAppFuture = _initApp();

    // Can't show a dialog in initState, delaying initialization
    WidgetsBinding.instance?.addPostFrameCallback((_) => _initAppTrackingTransparency());
  }

  @override
  bool get wantKeepAlive => true;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future _initAppTrackingTransparency() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      log("AppTrackingTransparency.trackingAuthorizationStatus -> Tracking status = $status", name: LOG_TAG);
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog
        if (await showCustomTrackingDialog(context)) {
          // Wait for dialog popping animation
          await Future.delayed(const Duration(milliseconds: 200));
          // Request system's tracking authorization dialog
          log("AppTrackingTransparency.requestTrackingAuthorization() -> starting", name: LOG_TAG);
          final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
          log("AppTrackingTransparency.requestTrackingAuthorization() -> Tracking status = $status", name: LOG_TAG);
          if (status == TrackingStatus.authorized) {
            final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
            log("AppTrackingTransparency.getAdvertisingIdentifier() -> UUID = $uuid", name: LOG_TAG);
          }
        }
      }
    } on PlatformException {
      log("App tracking transparency init error: platform exception", name: LOG_TAG);
    } catch (error) {
      log("App tracking transparency init error: $error", name: LOG_TAG);
    }
  }

  Future<bool> showCustomTrackingDialog(BuildContext context) async {
    final title = Text(translate(StringKeys.tracking_dialog_title, context));
    final content = Text(translate(StringKeys.tracking_dialog_text, context));
    final buttonLater = TextButton(
      child: Text(translate(StringKeys.tracking_dialog_button_later, context)),
      onPressed: () => Navigator.pop(context, false),
    );
    final buttonAllow = TextButton(
      child: Text(translate(StringKeys.tracking_dialog_button_allow, context)),
      onPressed: () => Navigator.pop(context, true),
    );
    final dialogWidget = AlertDialog(
      title: title,
      content: content,
      actions: [
        buttonAllow,
        buttonLater,
      ],
    );
    return await showDialog<bool>(
          context: context,
          builder: (context) => dialogWidget,
        ) ??
        false;
  }

  Future _initSystemData() async {
    try {
      await Firebase.initializeApp();
      if (kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      }
      if (kReleaseMode) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }
    } catch (error) {
      throw Exception("Firebase initialize error: $error");
    }

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
  }

  Future<bool> _initPlayer() async {
    _systemData.playerData.appTitle = translate(StringKeys.app_title, context);

    final SharedPreferences sp = await SharedPreferences.getInstance();

    final int audioQualityId = sp.getInt(KEY_AUDIO_QUALITY) ?? DEFAULT_AUDIO_QUALITY_ID;
    final int startPlayingId = sp.getInt(KEY_START_PLAYING) ?? DEFAULT_START_PLAYING_ID;

    late final bool isPlaying;
    switch (startPlayingId) {
      case START_PLAYING_START:
        isPlaying = true;
        break;
      case START_PLAYING_STOP:
        isPlaying = false;
        break;
      case START_PLAYING_LAST:
        isPlaying = sp.getBool(KEY_IS_PLAYING) ?? DEFAULT_IS_PLAYING;
        break;
      default:
        isPlaying = DEFAULT_IS_PLAYING;
        break;
    }

    log("_initPlayer() -> AudioService.init()", name: LOG_TAG);
    final playerHandler = await AudioService.init(
      builder: () => getKoin().get<AudioHandler>(),
      config: const AudioServiceConfig(
        androidNotificationChannelName: AUDIO_NOTIFICATION_CHANNEL_NAME,
        androidNotificationIcon: AUDIO_NOTIFICATION_ICON,
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
        notificationColor: Colors.lightGreenAccent,
      ),
    );

    await playerHandler.customAction(ACTION_START, _createPlayerTaskParams(audioQualityId, isPlaying));

    return isPlaying;
  }

  Map<String, dynamic> _createPlayerTaskParams(int audioQualityId, bool isPlaying) {
    final Map<String, dynamic> params = {
      KEY_APP_TITLE: _systemData.playerData.appTitle,
      KEY_URL_STREAM_LOW: _systemData.streamData.streamLow,
      KEY_URL_STREAM_MEDIUM: _systemData.streamData.streamMedium,
      KEY_URL_STREAM_HIGH: _systemData.streamData.streamHigh,
      KEY_URL_SCHEDULE: _systemData.xmlData.url,
      KEY_AUDIO_QUALITY: audioQualityId,
      KEY_IS_PLAYING: isPlaying,
    };
    return params;
  }

  Future<bool> _initApp() async {
    final bool isPlaying = await _initSystemData().then((_) => _initPlayer()).catchError((e) => _handleError(e));
    return isPlaying;
  }

  FutureOr<bool> _handleError(dynamic error) {
    final String msg = "App initialisation error";
    log("$msg: $error", name: LOG_TAG);
    throw Exception([msg, error]);
  }

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      initialData: DEFAULT_IS_PLAYING,
      future: _initAppFuture,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        final Widget homePage = _createHomePage(snapshot);
        return _wrapScreenUtilInit(homePage);
      },
    );
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
      return _createProgressPage();
    } else {
      return _createProgressPage();
    }
  }

  Widget _wrapScreenUtilInit(Widget homePage) {
    return ScreenUtilInit(designSize: Size(PROTOTYPE_DEVICE_WIDTH, PROTOTYPE_DEVICE_HEIGHT), builder: () => homePage);
  }

  List<String> _createInfoPageStrings() => ([
        translate(StringKeys.app_is_not_init_1, context),
        translate(StringKeys.app_is_not_init_2, context),
        translate(StringKeys.app_is_not_init_3, context),
        translate(StringKeys.app_is_not_init_4, context),
        translate(StringKeys.app_is_not_init_5, context),
      ]);

  Widget _createAppPage(bool isPlaying) =>
      BlocProvider.value(value: getWithParam<AppBloc, bool>(isPlaying), child: get<AppPage>());

  Widget _createProgressPage() => getWithParam<ProgressPage, String>(translate(StringKeys.app_init_title, context));
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => PlayerTask());
}
