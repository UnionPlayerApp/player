import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/shared_preferences.dart';
import 'package:union_player_app/utils/enums/audio_quality_type.dart';

import '../utils/core/string_keys.dart';
import 'listen_event.dart';
import 'listen_item_view.dart';
import 'listen_state.dart';

class ListenBloc extends Bloc<ListenEvent, ListenState> {
  static const _unknownIndex = -1;

  final AudioHandler _audioHandler;

  late final StreamSubscription _customSubscription;
  late final StreamSubscription _playerSubscription;
  late final StreamSubscription _queueSubscription;

  final _items = List<ListenItemView>.empty(growable: true);
  var _currentIndex = _unknownIndex;
  var _displayIndex = _unknownIndex;

  ListenBloc(this._audioHandler) : super(ListenState.empty()) {
    _customSubscription = _audioHandler.customEvent.listen((event) => _onCustom(event));
    _playerSubscription = _audioHandler.playbackState.listen((playbackState) => add(
          ListenPlaybackEvent(playbackState: playbackState),
        ));
    _queueSubscription = _audioHandler.queue.listen((queue) => _onQueue(queue));

    on<ListenAudioQualityEvent>(_onAudioQuality);
    on<ListenInitEvent>(_onInit);
    on<ListenLoadEvent>(_onLoad);
    on<ListenPlaybackEvent>(_onPlayback);
    on<ListenPlayerButtonEvent>(_onPlayerButton);
    on<ListenBackStepEvent>(_onBackStep);
    on<ListenForwardStepEvent>(_onForwardStep);

    add(ListenInitEvent());
  }

  FutureOr<void> _onInit(ListenInitEvent event, Emitter<ListenState> emitter) async {
    final audioQualityInt = await readIntFromSharedPreferences(keyAudioQuality);
    final audioQualityType = audioQualityInt?.audioQualityType ?? AudioQualityType.unknown;
    final newState = state.copyWith(
      audioQualityType: audioQualityType,
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

  FutureOr<void> _onAudioQuality(ListenAudioQualityEvent event, Emitter<ListenState> emitter) async {
    await _setAudioQuality(event.audioQualityType);
    final newState = state.copyWith(audioQualityType: event.audioQualityType);
    emitter(newState);
  }

  Future<void> _setAudioQuality(AudioQualityType audioQualityType) {
    final audioQualityInt = audioQualityType.integer;
    final params = {
      keyAudioQuality: audioQualityInt,
      keyIsPlaying: _audioHandler.playbackState.value.playing,
    };
    return Future.wait([
      _audioHandler.customAction(actionSetAudioQuality, params),
      writeIntToSharedPreferences(keyAudioQuality, audioQualityInt),
    ]);
  }

  FutureOr<void> _onPlayback(ListenPlaybackEvent event, Emitter<ListenState> emitter) async {
    final isPlayingChanged = state.isPlaying != event.playbackState.playing;
    final newState = state.copyWith(isPlaying: event.playbackState.playing);
    emitter(newState);
    if (isPlayingChanged) {
      writeBoolToSharedPreferences(keyIsPlaying, event.playbackState.playing);
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
