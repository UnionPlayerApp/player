import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/utils/constants/constants.dart';

class AppPlayer extends AudioPlayer {

  @override
  Future<void> play() async {
    FirebaseAnalytics.instance.logEvent(name: gaPlayerStart);
    return super.play();
  }

  @override
  Future<void> stop() async {
    FirebaseAnalytics.instance.logEvent(name: gaPlayerStop);
    return super.stop();
  }
}