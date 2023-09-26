import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/providers/shared_preferences_manager.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/enums/sound_quality_type.dart';

import '../utils/enums/string_keys.dart';
import 'listen_event.dart';
import 'listen_item_view.dart';
import 'listen_state.dart';

class ListenBloc extends Bloc<ListenEvent, ListenState> {
  static const _unknownIndex = -1;

  final AudioHandler _audioHandler;
  final SPManager _spManager;

  late final StreamSubscription _customSubscription;
  late final StreamSubscription _playerSubscription;
  late final StreamSubscription _queueSubscription;

  final _items = List<ListenItemView>.empty(growable: true);
  var _currentIndex = _unknownIndex;
  var _displayIndex = _unknownIndex;

  ListenBloc(this._audioHandler, this._spManager) : super(ListenState.empty()) {
    on<ListenSoundQualityEvent>(_onSoundQuality);
    on<ListenInitEvent>(_onInit);
    on<ListenLoadEvent>(_onLoad);
    on<ListenPlaybackEvent>(_onPlayback);
    on<ListenPlayerButtonEvent>(_onPlayerButton);
    on<ListenBackStepEvent>(_onBackStep);
    on<ListenForwardStepEvent>(_onForwardStep);

    _customSubscription = _audioHandler.customEvent.listen((event) => _onCustom(event));
    _playerSubscription = _audioHandler.playbackState.listen((playbackState) => add(
      ListenPlaybackEvent(playbackState: playbackState),
    ));
    _queueSubscription = _audioHandler.queue.listen((queue) => _onQueue(queue));

    add(ListenInitEvent());
  }

  FutureOr<void> _onInit(ListenInitEvent event, Emitter<ListenState> emitter) async {
    final soundQualityType = _spManager.readSoundQualityType();
    final newState = state.copyWith(
      soundQualityType: soundQualityType,
      isPlaying: _audioHandler.playbackState.value.playing,
    );
    emitter(newState);
  }

  FutureOr<void> _onLoad(ListenLoadEvent event, Emitter<ListenState> emitter) {
    if (event.mediaItems.isEmpty) {
      debugPrint("Main page, media item queue is empty");
      return Future.value();
    }

    _items.clear();
    _items.addAll(event.mediaItems.map((mediaItem) => ListenItemView.fromMediaItem(mediaItem)));

    _currentIndex = _unknownIndex;

    final now = DateTime.now();

    _items.asMap().forEach((index, item) {
      if (now.isAfter(item.finish)) {
        item.labelKey = StringKeys.prevLabel;
        return;
      }
      if (now.isBefore(item.start)) {
        item.labelKey = StringKeys.nextLabel;
        return;
      }
      item.labelKey = StringKeys.currLabel;
      _currentIndex = index;
    });

    if (_currentIndex == _unknownIndex && now.isBefore(_items.first.start)) {
      _currentIndex = 0;
    }

    if (_currentIndex == _unknownIndex && now.isAfter(_items.last.finish)) {
      _currentIndex = _items.length - 1;
    }

    _displayIndex = _currentIndex;

    final newState = state.copyWith(itemView: _items[_displayIndex]);
    emitter(newState);
  }

  void _onCustom(error) {
    debugPrint("MainBloc._onCustom(error), error = $error");
    add(ListenLoadEvent(isScheduleLoaded: false, loadingError: error));
  }

  _onQueue(List<MediaItem>? queue) {
    if (queue == null) {
      debugPrint("MainBloc._onQueue(queue) -> queue is null");
      _onCustom("Schedule load error: queue is null");
    } else if (queue.isEmpty) {
      debugPrint("MainBloc._onQueue(queue) -> queue is empty");
      _onCustom("Schedule load error: queue is empty");
    } else {
      debugPrint("MainBloc._onQueue(queue) -> queue has ${queue.length} items");
      add(ListenLoadEvent(isScheduleLoaded: true, mediaItems: queue));
    }
  }

  @override
  Future<void> close() {
    _customSubscription.cancel();
    _playerSubscription.cancel();
    _queueSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onSoundQuality(ListenSoundQualityEvent event, Emitter<ListenState> emitter) async {
    await _setSoundQuality(event.soundQualityType);
    final newState = state.copyWith(soundQualityType: event.soundQualityType);
    emitter(newState);
  }

  Future<void> _setSoundQuality(SoundQualityType soundQualityType) {
    final params = {
      keySoundQuality: soundQualityType.integer,
      keyIsPlaying: _audioHandler.playbackState.value.playing,
    };
    return Future.wait([
      _audioHandler.customAction(actionSetSoundQuality, params),
      _spManager.writeSoundQualityType(soundQualityType),
    ]);
  }

  FutureOr<void> _onPlayback(ListenPlaybackEvent event, Emitter<ListenState> emitter) async {
    final isPlayingChanged = state.isPlaying != event.playbackState.playing;
    final newState = state.copyWith(isPlaying: event.playbackState.playing);
    emitter(newState);
    if (isPlayingChanged) {
      _spManager.writeIsPlaying(event.playbackState.playing);
    }
  }

  FutureOr<void> _onPlayerButton(ListenPlayerButtonEvent event, Emitter<ListenState> emitter) {
    if (_audioHandler.playbackState.value.playing) {
      _audioHandler.pause();
    } else {
      _audioHandler.play();
    }
  }

  FutureOr<void> _onBackStep(ListenBackStepEvent event, Emitter<ListenState> emitter) {
    if (_items.isNotEmpty && _displayIndex > 0) {
      _displayIndex--;
      final newState = state.copyWith(itemView: _items[_displayIndex]);
      emitter(newState);
    }
  }

  FutureOr<void> _onForwardStep(ListenForwardStepEvent event, Emitter<ListenState> emitter) {
    if (_items.isNotEmpty && _displayIndex < _items.length - 1) {
      _displayIndex++;
      final newState = state.copyWith(itemView: _items[_displayIndex]);
      emitter(newState);
    }
  }
}
