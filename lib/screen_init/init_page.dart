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
import 'package:union_player_app/screen_app/app_bloc.dart';
import 'package:union_player_app/screen_app/app_page.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';
import 'package:union_player_app/utils/dimensions/dimensions.dart';
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
    log(_systemData.streamData.streamMedium);

    final assetPath = "assets/images/union_radio_logo_1.png";

    late final Uri artUri;

    try {
      final file = await loadAssetFile(assetPath);
      artUri = file.uri;
    } catch (error) {
      log("Load asset file error: $error", name: LOG_TAG);
      artUri = Uri();
    }

    log("loadAssetFile -> assetPath = $assetPath, artUri = $artUri", name: LOG_TAG);

    final mediaItem = MediaItem(
      id: _systemData.streamData.streamMedium,
      album: "album: Union Radio 1",
      title: "title: Current program",
      genre: "genre: music",
      artUri: artUri,
      displayDescription: "display description",
      displaySubtitle: "display subtitle",
      displayTitle: "display title",
    );

    try {
      await AudioService.playMediaItem(mediaItem);
    } catch (error) {
      throw Exception("Audio stream load error: $error");
    }
  }

  Future _initApp() async => _initSystemData().then((v) {
        _handleSuccess("System data init success");
        _initPlayer()
            .then((value) => _handleSuccess("Player init success"))
            .catchError((e) => _handleError("Player init error", e));
      }).catchError((e) => _handleError("System data init error", e));

  FutureOr<Null> _handleSuccess(String msg) {
    log(msg, name: LOG_TAG);
  }

  FutureOr<Null> _handleError(String msg, dynamic error) {
    log("$msg: $error", name: LOG_TAG);
    throw Exception(["App initialisation error", error]);
  }

  @override
  void dispose() {
    super.dispose();
    AudioService.stop();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _initApp(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          late final Widget homePage;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              homePage = getWithParam<InfoPage, List<String>>([
                "Ошибка запуска приложения",
                "К сожалению, сейчас нет возможности запустить приложение.",
                "Специалисты уже работают над устранением проблемы.",
                "Попробуйте запустить приложение позже.",
                "Приносим извинения за предоставленные неудобства!"
              ]);
            } else {
              homePage = BlocProvider(create: (context) => get<AppBloc>(), child: get<AppPage>());
            }
          } else {
            homePage = getWithParam<LoadingPage, String>("App initializing...");
          }
          return _createAppPage(homePage);
        },
      );

  Widget _createAppPage(Widget homePage) {
    return ScreenUtilInit(designSize: Size(prototypeDeviceWidth, prototypeDeviceHeight), builder: () => homePage);
  }
}
