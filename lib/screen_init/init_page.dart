import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:koin_flutter/koin_flutter.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
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

class _InitPageState extends State<InitPage> {
  late final SystemData _systemData;

  @override
  void initState() {
    super.initState();

    _systemData = get<SystemData>();
  }

  Future _initSystemData() async {
    try {
      await Firebase.initializeApp();
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

  Future _initPlayer() async {
    _systemData.playerData.appTitle = translate(StringKeys.app_title, context);

    await AudioService.start(
      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
      params: _createPlayerTaskParams(),
      androidNotificationChannelName: AUDIO_NOTIFICATION_CHANNEL_NAME,
      androidNotificationColor: Colors.lightGreenAccent.value,
      androidNotificationIcon: AUDIO_NOTIFICATION_ICON,
      androidShowNotificationBadge: true,
      androidEnableQueue: true,
    );
  }

  Map<String, dynamic> _createPlayerTaskParams() {
    final Map<String, dynamic> params = {
      "app_title": _systemData.playerData.appTitle,
      "url_stream_low": _systemData.streamData.streamLow,
      "url_stream_medium": _systemData.streamData.streamMedium,
      "url_stream_high": _systemData.streamData.streamHigh,
      "url_schedule": _systemData.xmlData.url,
      "audio_quality": AUDIO_QUALITY_MEDIUM,
      "is_playing": true,
    };
    return params;
  }

  Future _initApp() async {
    log("init app start", name: LOG_TAG);
    await _initSystemData()
        .then((v) => _handleSuccess("System data init success"))
        .catchError((e) => _handleError("System data init error", e));
    await _initPlayer()
        .then((v) => _handleSuccess("Player init success"))
        .catchError((e) => _handleError("Player init error", e));
  }

  FutureOr<Null> _handleSuccess(String msg) {
    log(msg, name: LOG_TAG);
  }

  FutureOr<Null> _handleError(String msg, dynamic error) {
    log("$msg: $error", name: LOG_TAG);
    throw Exception(["App initialisation error", error]);
  }

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _initApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late final Widget homePage;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              homePage = getWithParam<InfoPage, List<String>>(_createInfoPageStrings());
            } else {
              log("FutureBuilder() -> builder -> no error -> AppPage start", name: LOG_TAG);
              homePage = _createAppPage();
            }
          } else {
            homePage = _createProgressPage();
          }
          return _wrapScreenUtilInit(homePage);
        },
      );

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

  Widget _createAppPage() => BlocProvider.value(value: get<AppBloc>(), child: get<AppPage>());

  Widget _createProgressPage() => getWithParam<ProgressPage, String>(translate(StringKeys.app_init_title, context));
}

void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => PlayerTask());
}
