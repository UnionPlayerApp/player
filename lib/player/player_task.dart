import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/utils/constants/constants.dart';

class PlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    _eventSubscription = _player.playbackEventStream.listen((event) => _broadcastState());
  }

  @override
  Future<void> onStop() async {
    log("AudioPlayerTask.onStop()", name: LOG_TAG);
    await _player.dispose();
    _eventSubscription.cancel();
    await _broadcastState();
    await super.onStop();
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();


  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    AudioServiceBackground.setMediaItem(mediaItem);

    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItem.id)));
    } catch (e) {
      log("Audio source init error: $e", name: LOG_TAG);
      onStop();
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        if (_player.playing) MediaControl.stop else MediaControl.play,
      ],
      androidCompactActions: [0],
      processingState: _getProcessingState(),
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  AudioProcessingState _getProcessingState() {
    switch (_player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }
}
