import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/repository/schedule_repository_impl.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';

class PlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
  final _schedule = ScheduleRepositoryImpl();

  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<ScheduleRepositoryState> _scheduleStateSubscription;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    _playerStateSubscription = _player.playerStateStream.listen((state) => _broadcastPlayerState());
    _scheduleStateSubscription = _schedule.stateStream().listen((state) => _broadcastScheduleState(state));
  }

  @override
  Future<void> onStop() async {
    log("AudioPlayerTask.onStop()", name: LOG_TAG);
    await _scheduleStateSubscription.cancel();
    await _playerStateSubscription.cancel();
    await _player.dispose();
    await _schedule.onStop();
    await _broadcastPlayerState();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async => await _player.play();

  @override
  Future<void> onPause() async => await _player.pause();

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItem.id)));
      await AudioServiceBackground.setMediaItem(mediaItem);
    } catch (e) {
      log("Audio source init error: $e", name: LOG_TAG);
      onStop();
    }
  }

  /// Broadcasts the current player state to all clients.
  Future<void> _broadcastPlayerState() async {
    await AudioServiceBackground.setState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
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

  Future<void> _broadcastScheduleState(ScheduleRepositoryState state) async {
    if (state is ScheduleRepositoryLoadSuccessState) {
      final queue = state.items.map((scheduleItem) => _mapScheduleItemRawToMediaItem(scheduleItem)).toList();
      AudioServiceBackground.setQueue(queue);
    }

    if (state is ScheduleRepositoryLoadErrorState) {
      AudioServiceBackground.sendCustomEvent(state.error);
    }
  }

  MediaItem _mapScheduleItemRawToMediaItem(ScheduleItemRaw scheduleItem) {
    final Map<String, dynamic> extras = {
      "start": scheduleItem.start,
      "guest": scheduleItem.guest,
      "type": scheduleItem.type
    };

    return MediaItem(
      id: '',
      album: APP_INTERNATIONAL_TITLE,
      artUri: scheduleItem.uri,
      artist: scheduleItem.artist,
      displayDescription: scheduleItem.description,
      displaySubtitle: scheduleItem.artist,
      displayTitle: scheduleItem.title,
      duration: scheduleItem.duration,
      extras: extras,
      genre: scheduleItem.genre,
      title: scheduleItem.title,
    );
  }
}

extension _ScheduleItemRawExtension on ScheduleItemRaw {

  String get genre {
    switch (this.type) {
      case ScheduleItemType.music: return "music";
      case ScheduleItemType.news: return "news";
      case ScheduleItemType.talk: return "talk";
      default: return "unknown";
    }
  }

  Uri? get uri => (this.imageUrl == null) ? null : Uri.parse(this.imageUrl!);
}
