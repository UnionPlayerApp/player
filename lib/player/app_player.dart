import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/utils/constants/constants.dart';

class AppPlayer extends AudioPlayer {

  @override
  Future<void> play() async {
    FirebaseAnalytics().logEvent(name: GA_PLAYER_START);
    return super.play();
  }

  @override
  Future<void> stop() async {
    FirebaseAnalytics().logEvent(name: GA_PLAYER_STOP);
    return super.stop();
  }
}