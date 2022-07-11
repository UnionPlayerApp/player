import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as Math;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/repository/schedule_repository_impl.dart';
import 'package:union_player_app/repository/schedule_repository_event.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';
import 'package:uuid/uuid.dart';

import 'app_player.dart';

class PlayerTask extends BackgroundAudioTask {
  final _player = AppPlayer();
  final _schedule = ScheduleRepositoryImpl();
  final _uuid = Uuid();
  final _random = Math.Random();

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
  late final StreamSubscription<ScheduleRepositoryEvent> _scheduleStateSubscription;
  late final StreamSubscription<AudioInterruptionEvent> _sessionEventSubscription;

  bool _isPlayingBeforeInterruption = false;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    assert(params != null, "PlayerTask.onStart() params must be not null");

    _appTitle = params![KEY_APP_TITLE];
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

    _playerStateSubscription = _player.playerStateStream.listen((state) => _broadcastPlayerState());
    _scheduleStateSubscription = _schedule.stateStream().listen((state) => _broadcastScheduleState(state));
    _sessionEventSubscription = session.interruptionEventStream.listen((event) => _handleAudioInterruptionEvent(event));

    _schedule.start(_urlSchedule);

    onCustomAction(ACTION_SET_AUDIO_QUALITY, params);
  }

  @override
  Future<void> onStop() async {
    log("AudioPlayerTask.onStop()", name: LOG_TAG);
    await _scheduleStateSubscription.cancel();
    await _playerStateSubscription.cancel();
    await _sessionEventSubscription.cancel();
    await _player.dispose();
    await _schedule.stop();
    await _broadcastPlayerState();
    await super.onStop();
  }

  @override
  Future<void> onPlay() async {
    if (!_player.playing) {
      _isPlayingBeforeInterruption = true;
      return _player.play();
    }
  }

  @override
  Future<void> onPause() async {
    if (_player.playing) {
      _isPlayingBeforeInterruption = false;
      return _player.stop();
    }
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async => await AudioServiceBackground.setMediaItem(mediaItem);

  @override
  Future<void> onCustomAction(String name, dynamic arguments) async {
    switch (name) {
      case ACTION_SET_AUDIO_QUALITY:
        return onSetAudioQuality(arguments);
      default:
        return super.onCustomAction(name, arguments);
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
      await _player.stop();
      await _player.setUrl(audioUrl);
      if (isPlaying) {
        await _player.play();
      }
      _isPlayingBeforeInterruption = isPlaying;
    } catch (error) {
      log("Audio stream ($audioUrl) load (set url) or stop/play error: $error", name: LOG_TAG);
    }
  }

  /// Broadcasts the current player state to all clients.
  Future<void> _broadcastPlayerState() async {
    log("PlayerTask._broadcastPlayerState()", name: LOG_TAG);
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
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }

  Future<void> _broadcastScheduleState(ScheduleRepositoryEvent state) async {
    if (state is ScheduleRepositorySuccessEvent) {
      log("PlayerTask._broadcastScheduleState() -> success -> is queue has ${state.items.length} items", name: LOG_TAG);
      final queue = state.items.map((scheduleItem) => _mapScheduleItemToMediaItem(scheduleItem)).toList();
      AudioServiceBackground.setQueue(queue);
      if (queue.isNotEmpty) {
        AudioServiceBackground.setMediaItem(queue[0]);
        log("AudioServiceBackground.setMediaItem() -> artUri = ${queue[0].artUri}", name: LOG_TAG);
      }
    }

    if (state is ScheduleRepositoryErrorEvent) {
      log("PlayerTask._broadcastScheduleState() -> error -> ${state.error}", name: LOG_TAG);
      AudioServiceBackground.sendCustomEvent(state.error);
    }
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
            _player.stop();
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
