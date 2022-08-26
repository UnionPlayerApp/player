import 'dart:async';
import 'dart:io';
import 'dart:math' as Math;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/repository/schedule_repository_event.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';
import 'package:uuid/uuid.dart';

class AppPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer player;
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

  late final StreamSubscription<ScheduleRepositoryEvent> _scheduleStateSubscription;
  late final StreamSubscription<AudioInterruptionEvent> _sessionEventSubscription;

  bool _isPlayingBeforeInterruption = false;

  AppPlayerHandler({required this.player, required this.schedule, required this.random, required this.uuid});

  @override
  Future<void> play() async {
    if (!player.playing) {
      _isPlayingBeforeInterruption = true;
      return player.play();
    }
  }

  @override
  Future<void> pause() async {
    if (player.playing) {
      _isPlayingBeforeInterruption = false;
      return player.stop();
    }
  }

  @override
  Future<void> stop() async {
    await _scheduleStateSubscription.cancel();
    await _sessionEventSubscription.cancel();
    await player.dispose();
    await schedule.stop();
    super.stop();
  }

  @override
  Future<dynamic> customAction(String action, [Map<String, dynamic>? extras]) {
    switch (action) {
      case ACTION_SET_AUDIO_QUALITY:
        return _setAudioQuality(extras);
      case ACTION_START:
        return _start(extras);
      default:
        return super.customAction(action, extras);
    }
  }

  // Set audio quality and start / pause audio stream
  Future<void> _setAudioQuality(dynamic arguments) async {
    final Map<String, dynamic> params = Map.from(arguments);

    final int audioQuality = params[KEY_AUDIO_QUALITY] ?? DEFAULT_AUDIO_QUALITY_ID;
    final bool isPlaying = params[KEY_IS_PLAYING] ?? DEFAULT_IS_PLAYING;

    final audioUrl = _mapAudioQualityToUrl(audioQuality);

    try {
      await player.stop();
      await player.setUrl(audioUrl);
      if (isPlaying) {
        await player.play();
      }
      _isPlayingBeforeInterruption = isPlaying;
      debugPrint("set audio stream = $audioUrl");
    } catch (error) {
      debugPrint("audio stream ($audioUrl) load / stop / play error: $error");
      customEvent.add(error.toString());
    }
  }

  // Start audio stream and set audio quality
  Future<void> _start(dynamic arguments) async {
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

    player.playbackEventStream.map(_transformPlaybackEvent).pipe(playbackState);
    _scheduleStateSubscription = schedule.stateStream().listen(_handleScheduleEvent);
    _sessionEventSubscription = session.interruptionEventStream.listen(_handleInterruptionEvent);

    schedule.start(_urlSchedule);

    _setAudioQuality(arguments);
  }

  PlaybackState _transformPlaybackEvent(PlaybackEvent event) => PlaybackState(
        controls: [
          if (player.playing) MediaControl.pause else MediaControl.play,
        ],
        androidCompactActionIndices: const [0],
        processingState: _processingState(),
        playing: player.playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      );

  AudioProcessingState _processingState() => const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[player.processingState]!;

  Future<Uri> _createUriFromAsset(String asset) async {
    try {
      File file = await loadAssetFile(asset);
      return Uri.file(file.path);
    } catch (error) {
      debugPrint("Load asset file ($asset) error: $error");
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
        debugPrint("Unknown AudioQualityType $audioQuality. Default quality (medium) used.");
        return _urlStreamMedium;
    }
  }

  Future<void> _handleScheduleEvent(ScheduleRepositoryEvent event) async {
    if (event is ScheduleRepositorySuccessEvent) {
      debugPrint("schedule -> new queue has ${event.items.length} items");
      final nextItems = event.items.map(_mapScheduleItemToMediaItem).toList();
      queue.add(nextItems);
      if (nextItems.isNotEmpty) mediaItem.add(nextItems[0]);
    }

    if (event is ScheduleRepositoryErrorEvent) {
      debugPrint("schedule -> load error -> ${event.error}");
      customEvent.add(event.error);
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

  _handleInterruptionEvent(AudioInterruptionEvent event) {
    if (event.begin) {
      debugPrint(
        "audio interruption event => begin => is playing before interruption = $_isPlayingBeforeInterruption",
      );
      switch (event.type) {
        case AudioInterruptionType.duck:
          break;
        case AudioInterruptionType.pause:
        case AudioInterruptionType.unknown:
          if (_isPlayingBeforeInterruption) {
            debugPrint("audio interruption event => player stop");
            player.stop();
          }
          break;
      }
    } else {
      debugPrint(
        "audio interruption event => finish => is playing before interruption = $_isPlayingBeforeInterruption",
      );
      switch (event.type) {
        case AudioInterruptionType.duck:
          break;
        case AudioInterruptionType.pause:
        case AudioInterruptionType.unknown:
          if (_isPlayingBeforeInterruption) {
            debugPrint("audio interruption event => player play");
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
          debugPrint("Unknown schedule item type $type. \"Unknown\" item type is used.");
          return "unknown";
        }
    }
  }
}

extension MediaItemExtensions on MediaItem {
  DateTime get start => DateTime.fromMicrosecondsSinceEpoch(this.extras!["start"]);

  int get type => this.extras!["type"];
}
