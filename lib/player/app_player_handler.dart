import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/repository/schedule_repository_event.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/common/constants/constants.dart';
import 'package:union_player_app/common/core/file_utils.dart';
import 'package:union_player_app/common/enums/sound_quality_type.dart';
import 'package:uuid/uuid.dart';

class AppPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;
  final IScheduleRepository _schedule;
  final Uuid _uuid;
  final math.Random _random;

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

  AppPlayerHandler(this._player, this._schedule, this._random, this._uuid);

  @override
  Future<void> play() async {
    if (!_player.playing) {
      _isPlayingBeforeInterruption = true;
      return _player.play();
    }
  }

  @override
  Future<void> pause() async {
    if (_player.playing) {
      _isPlayingBeforeInterruption = false;
      return _player.stop();
    }
  }

  @override
  Future<void> stop() async {
    debugPrint("app player handler has been stopping");
    await _scheduleStateSubscription.cancel();
    await _sessionEventSubscription.cancel();
    await _player.dispose();
    await _schedule.stop();
    debugPrint("app player handler was stopped");
  }

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? extras]) {
    switch (name) {
      case actionSetSoundQuality:
        return _setSoundQuality(extras);
      case actionStart:
        return _start(extras);
      default:
        return super.customAction(name, extras);
    }
  }

  // Set audio quality and start / pause audio stream
  Future<void> _setSoundQuality(dynamic arguments) async {
    final Map<String, dynamic> params = Map.from(arguments);

    final soundQuality = params[keySoundQuality];
    final isPlaying = params[keyIsPlaying];

    assert(
      soundQuality is int && isPlaying is bool,
      "Incorrect parameters set sound quality custom action: $arguments",
    );

    soundQuality as int;
    isPlaying as bool;

    final audioUrl = _mapSoundQualityToUrl(soundQuality.soundQualityType);

    try {
      await _player.stop();
      await _player.setUrl(audioUrl);
      if (isPlaying) {
        _player.play();
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

    _appTitle = params[keyAppTitle];
    _urlStreamLow = params[keyUrlStreamLow];
    _urlStreamMedium = params[keyUrlStreamMedium];
    _urlStreamHigh = params[keyUrlStreamHigh];
    _urlSchedule = params[keyUrlSchedule];

    _appArtUri = await _createUriFromAsset(audioBackgroundTaskLogoAsset);
    _newsArtUriList = await _createUriListFromAssetList(newsArtAssetList);
    _talkArtUriList = await _createUriListFromAssetList(talkArtAssetList);
    _musicArtUriList = await _createUriListFromAssetList(musicArtAssetList);

    final session = await AudioSession.instance;
    final configuration = const AudioSessionConfiguration.music().copyWith(androidWillPauseWhenDucked: false);
    await session.configure(configuration);

    _player.playbackEventStream.map(_transformPlaybackEvent).pipe(playbackState);
    _scheduleStateSubscription = _schedule.stateStream().listen(_handleScheduleEvent);
    _sessionEventSubscription = session.interruptionEventStream.listen(_handleInterruptionEvent);

    _schedule.start(_urlSchedule);

    _setSoundQuality(arguments);
  }

  PlaybackState _transformPlaybackEvent(PlaybackEvent event) => PlaybackState(
        controls: [
          if (_player.playing) MediaControl.pause else MediaControl.play,
        ],
        androidCompactActionIndices: const [0],
        processingState: _processingState(),
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      );

  AudioProcessingState _processingState() => const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!;

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
    for (var asset in assetList) {
      final path = await _createUriFromAsset(asset);
      uriList.add(path);
    }
    return uriList;
  }

  String _mapSoundQualityToUrl(SoundQualityType soundQuality) {
    switch (soundQuality) {
      case SoundQualityType.low:
        return _urlStreamLow;
      case SoundQualityType.medium:
        return _urlStreamMedium;
      case SoundQualityType.high:
        return _urlStreamHigh;
    }
  }

  Future<void> _handleScheduleEvent(ScheduleRepositoryEvent event) async {
    if (event is ScheduleRepositorySuccessEvent) {
      if (event.items.isNotEmpty) {
        debugPrint("schedule -> new queue has ${event.items.length} items");
        final nextMediaItems = event.items.map(_mapScheduleItemToMediaItem).toList();
        queue.add(nextMediaItems);
      } else {
        debugPrint("schedule -> new queue is empty");
      }
      if (event.currentItem != null) {
        debugPrint("schedule -> updating current item by ${event.currentItem}");
        final currentMediaItem = _mapScheduleItemToMediaItem(event.currentItem!);
        mediaItem.add(currentMediaItem);
      } else {
        debugPrint("schedule -> current item is not defined");
      }
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
      id: _uuid.v1(),
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
    final int index = _random.nextInt(uriList.length - 1);
    return uriList[index];
  }

  void _handleInterruptionEvent(AudioInterruptionEvent event) {
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
            _player.stop();
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
            _player.play();
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
  DateTime get start => DateTime.fromMicrosecondsSinceEpoch(extras!["start"]);

  int get type => extras!["type"];
}
