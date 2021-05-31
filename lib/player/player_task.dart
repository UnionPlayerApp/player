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
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';
import 'package:uuid/uuid.dart';

class PlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();
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
  late final StreamSubscription<ScheduleRepositoryState> _scheduleStateSubscription;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    assert(params != null, "PlayerTask.onStart() params must be not null");

    log("PlayerTask.onStart()", name: LOG_TAG);

    _appTitle = params!["app_title"];
    _urlStreamLow = params["url_stream_low"];
    _urlStreamMedium = params["url_stream_medium"];
    _urlStreamHigh = params["url_stream_high"];
    _urlSchedule = params["url_schedule"];

    _appArtUri = await _createUriFromAsset(AUDIO_BACKGROUND_TASK_LOGO_ASSET);
    _newsArtUriList = await _createUriListFromAssetList(NEWS_ART_ASSET_LIST);
    _talkArtUriList = await _createUriListFromAssetList(TALK_ART_ASSET_LIST);
    _musicArtUriList = await _createUriListFromAssetList(MUSIC_ART_ASSET_LIST);

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());

    _playerStateSubscription = _player.playerStateStream.listen((state) => _broadcastPlayerState());
    _scheduleStateSubscription = _schedule.stateStream().listen((state) => _broadcastScheduleState(state));

    _schedule.onStart(_urlSchedule);

    onCustomAction("", params);
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
  Future<void> onPlayMediaItem(MediaItem mediaItem) async => await AudioServiceBackground.setMediaItem(mediaItem);

  // Set audio quality and start / pause audio stream
  @override
  Future<void> onCustomAction(String name, dynamic arguments) async {
    final Map<String, dynamic> args = arguments;

    final int audioQuality = args["audio_quality"];
    final bool isPlaying = args["is_playing"];

    log("PlayerTask.onCustomAction(), audio quality = $audioQuality, is playing = $isPlaying", name: LOG_TAG);

    final audioUrl = _mapAudioQualityToUrl(audioQuality);
    try {
      await _player.setUrl(audioUrl);

      if (isPlaying) {
        await _player.play();
      } else {
        await _player.pause();
      }
    } catch (error) {
      log("Audio stream ($audioUrl) load or play/pause error: $error");
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
      "type":  scheduleItem.type.toInt
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

  Future <List<Uri>> _createUriListFromAssetList(List<String> assetList) async {
    final List<Uri> uriList = List.empty(growable: true);
    assetList.forEach((asset) async {
      final path = await _createUriFromAsset(asset);
      uriList.add(path);
    });
    return uriList;
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

  Uri? get uri => (imageUrl == null) ? null : Uri.parse(imageUrl!);
}

extension MediaItemExtensions on MediaItem {

  DateTime get start => DateTime.fromMicrosecondsSinceEpoch(this.extras!["start"]);
  int get type => this.extras!["type"];
}