import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';
import 'package:uuid/uuid.dart';

import 'app_player.dart';

class AppPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AppPlayer player;
  final IScheduleRepository schedule;
  final Uuid uuid;
  final Math.Random random;

  late final String _appTitle;
  late final Uri _appArtUri;
  late final String _urlStreamLow;
  late final String _urlStreamMedium;
  late final String _urlStreamHigh;
  late final String _urlSchedule;
  late final List<Uri> _newsArtUriList;
  late final List<Uri> _talkArtUriList;
  late final List<Uri> _musicArtUriList;

  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<ScheduleRepositoryState> _scheduleStateSubscription;
  late final StreamSubscription<AudioInterruptionEvent> _sessionEventSubscription;

  bool _isPlayingBeforeInterruption = false;

  AppPlayerHandler({required this.player, required this.schedule, required this.random, required this.uuid}) {
    player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => player.play();

  @override
  Future<void> pause() => player.pause();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> stop() => player.stop();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!,
      playing: player.playing,
      updatePosition: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
      queueIndex: event.currentIndex,
    );
  }

  Future<Uri> _createUriFromAsset(String asset) async {
    try {
      File file = await loadAssetFile(asset);
      return Uri.file(file.path);
    } catch (error) {
      log("Load asset file ($asset) error: $error", name: LOG_TAG);
      return Uri();
    }
  }

  Future<List<Uri>> _createUriListFromAssetList(List<String> assetList) async {
    final List<Uri> uriList = List.empty(growable: true);
    assetList.forEach((asset) async {
      final path = await _createUriFromAsset(asset);
      uriList.add(path);
    });
    return uriList;
  }

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? extras]) {
    switch (name) {
      case PLAYER_TASK_ACTION_SET_AUDIO_QUALITY:
        return onSetAudioQuality(extras);
      case PLAYER_TASK_ACTION_SET_PARAMS:
        return onSetParams(extras);
      default:
        return super.customAction(name, extras);
    }
  }

  // Set audio quality and start / pause audio stream
  Future<void> onSetAudioQuality(dynamic arguments) async {
    final Map<String, dynamic> params = Map.from(arguments);
    final int audioQuality = params[KEY_AUDIO_QUALITY] ?? DEFAULT_AUDIO_QUALITY_ID;
    final bool isPlaying = params[KEY_IS_PLAYING] ?? DEFAULT_IS_PLAYING;
    final audioUrl = _mapAudioQualityToUrl(audioQuality);
    log("PlayerTask.onCustomAction(), set audio stream = $audioUrl", name: LOG_TAG);
    try {
      await player.stop();
      await player.setUrl(audioUrl);
      if (isPlaying) {
        await player.play();
      }
      _isPlayingBeforeInterruption = isPlaying;
    } catch (error) {
      log("Audio stream ($audioUrl) load (set url) or stop/play error: $error", name: LOG_TAG);
    }
  }

  // Set audio quality and start / pause audio stream
  Future<void> onSetParams(dynamic arguments) async {
    final Map<String, dynamic> params = Map.from(arguments);

    _appTitle = params[KEY_APP_TITLE];
    _urlStreamLow = params[KEY_URL_STREAM_LOW];
    _urlStreamMedium = params[KEY_URL_STREAM_MEDIUM];
    _urlStreamHigh = params[KEY_URL_STREAM_HIGH];
    _urlSchedule = params[KEY_URL_SCHEDULE];

    _appArtUri = await _createUriFromAsset(AUDIO_BACKGROUND_TASK_LOGO_ASSET);
    _newsArtUriList = await _createUriListFromAssetList(NEWS_ART_ASSET_LIST);
    _talkArtUriList = await _createUriListFromAssetList(TALK_ART_ASSET_LIST);
    _musicArtUriList = await _createUriListFromAssetList(MUSIC_ART_ASSET_LIST);

    final session = await AudioSession.instance;
    final configuration = AudioSessionConfiguration.music().copyWith(androidWillPauseWhenDucked: false);
    await session.configure(configuration);

    _playerStateSubscription = player.playerStateStream.listen((state) => _broadcastPlayerState());
    _scheduleStateSubscription = schedule.stateStream().listen((state) => _broadcastScheduleState(state));
    _sessionEventSubscription = session.interruptionEventStream.listen((event) => _handleAudioInterruptionEvent(event));

    schedule.onStart(_urlSchedule);

    onSetAudioQuality(arguments);
  }

  String _mapAudioQualityToUrl(int audioQuality) {
    switch (audioQuality) {
      case AUDIO_QUALITY_LOW:
        return _urlStreamLow;
      case AUDIO_QUALITY_MEDIUM:
        return _urlStreamMedium;
      case AUDIO_QUALITY_HIGH:
        return _urlStreamHigh;
      case AUDIO_QUALITY_UNDEFINED:
        return _urlStreamMedium;
      default:
        {
          log("Unknown AudioQualityType $audioQuality. Default quality (medium) used.", name: LOG_TAG);
          return _urlStreamMedium;
        }
    }
  }

  /// Broadcasts the current player state to all clients.
  Future<void> _broadcastPlayerState() async {
    log("PlayerTask._broadcastPlayerState()", name: LOG_TAG);
    await AudioServiceBackground.setState(
      controls: [
        if (player.playing) MediaControl.pause else MediaControl.play,
      ],
      androidCompactActions: [0],
      processingState: _getProcessingState(),
      playing: player.playing,
      position: player.position,
      bufferedPosition: player.bufferedPosition,
      speed: player.speed,
    );
  }

  AudioProcessingState _getProcessingState() {
    switch (player.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${player.processingState}");
    }
  }

  Future<void> _broadcastScheduleState(ScheduleRepositoryState state) async {
    if (state is ScheduleRepositoryLoadSuccessState) {
      log("PlayerTask._broadcastScheduleState() -> success -> is queue has ${state.items.length} items", name: LOG_TAG);
      final queue = state.items.map((scheduleItem) => _mapScheduleItemToMediaItem(scheduleItem)).toList();
      AudioServiceBackground.setQueue(queue);
      if (queue.isNotEmpty) {
        AudioServiceBackground.setMediaItem(queue[0]);
        log("AudioServiceBackground.setMediaItem() -> artUri = ${queue[0].artUri}", name: LOG_TAG);
      }
    }

    if (state is ScheduleRepositoryLoadErrorState) {
      log("PlayerTask._broadcastScheduleState() -> error -> ${state.error}", name: LOG_TAG);
      AudioServiceBackground.sendCustomEvent(state.error);
    }
  }

  MediaItem _mapScheduleItemToMediaItem(ScheduleItem scheduleItem) {
    final Map<String, dynamic> extras = {
      "start": scheduleItem.start.microsecondsSinceEpoch,
      "type": scheduleItem.type.toInt
    };

    late final Uri artUri;

    switch (scheduleItem.type) {
      case ScheduleItemType.news:
        artUri = _getRandomUri(_newsArtUriList);
        break;
      case ScheduleItemType.music:
        artUri = _getRandomUri(_musicArtUriList);
        break;
      case ScheduleItemType.talk:
        artUri = _getRandomUri(_talkArtUriList);
        break;
      case ScheduleItemType.indefinite:
        artUri = _appArtUri;
        break;
      default:
        artUri = _appArtUri;
        break;
    }

    return MediaItem(
      id: uuid.v1(),
      album: _appTitle,
      artUri: artUri,
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

  Uri _getRandomUri(List<Uri> uriList) {
    assert(uriList.isNotEmpty);
    final int index = random.nextInt(uriList.length - 1);
    return uriList[index];
  }

  _handleAudioInterruptionEvent(AudioInterruptionEvent event) {
    if (event.begin) {
      log("_handleAudioInterruptionEvent() => event.begin = true => _isPlayingBeforeInterruption = $_isPlayingBeforeInterruption",
          name: LOG_TAG);
      switch (event.type) {
        case AudioInterruptionType.duck:
          break;
        case AudioInterruptionType.pause:
        case AudioInterruptionType.unknown:
          log("_handleAudioInterruptionEvent() => check", name: LOG_TAG);
          if (_isPlayingBeforeInterruption) {
            log("_handleAudioInterruptionEvent() => _player.stop()", name: LOG_TAG);
            player.stop();
          }
          break;
      }
    } else {
      log("_handleAudioInterruptionEvent() => event.begin = false => _isPlayingBeforeInterruption = $_isPlayingBeforeInterruption",
          name: LOG_TAG);
      switch (event.type) {
        case AudioInterruptionType.duck:
          break;
        case AudioInterruptionType.pause:
        case AudioInterruptionType.unknown:
          log("_handleAudioInterruptionEvent() => check", name: LOG_TAG);
          if (_isPlayingBeforeInterruption) {
            log("_handleAudioInterruptionEvent() => _player.play()", name: LOG_TAG);
            player.play();
          }
          break;
      }
    }
  }
}

extension _ScheduleItemRawExtension on ScheduleItem {
  String get genre {
    switch (type) {
      case ScheduleItemType.music:
        return "music";
      case ScheduleItemType.news:
        return "news";
      case ScheduleItemType.talk:
        return "talk";
      default:
        {
          log("Unknown ScheduleItemType $type. \"Unknown\" item type is used.", name: LOG_TAG);
          return "unknown";
        }
    }
  }
}

extension MediaItemExtensions on MediaItem {
  DateTime get start => DateTime.fromMicrosecondsSinceEpoch(this.extras!["start"]);

  int get type => this.extras!["type"];
}

