import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/core/string_keys.dart';
import 'listen_event.dart';
import 'listen_item_view.dart';
import 'listen_state.dart';

class ListenBloc extends Bloc<ListenEvent, ListenState> {
  final AudioHandler _audioHandler;

  late final StreamSubscription _queueSubscription;
  late final StreamSubscription _customSubscription;

  final _items = List<ListenItemView>.empty(growable: true);

  ListenBloc(this._audioHandler) : super(const ListenState()) {
    _customSubscription = _audioHandler.customEvent.listen((event) => _onCustom(event));
    _queueSubscription = _audioHandler.queue.listen((queue) => _onQueue(queue));

    on<ListenEvent>(_onMain);
  }

  FutureOr<void> _onMain(ListenEvent event, Emitter<ListenState> emitter) {
    if (event.mediaItems.isEmpty) {
      debugPrint("Main page, media item queue is empty");
      return Future.value();
    }

    _items.clear();
    _items.addAll(event.mediaItems.map((mediaItem) => ListenItemView.fromMediaItem(mediaItem)));

    var currentIndex = -1;

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
      currentIndex = index;
    });

    if (currentIndex == -1 && now.isBefore(_items.first.start)) {
      currentIndex = 0;
    }

    if (currentIndex == -1 && now.isAfter(_items.last.finish)) {
      currentIndex = _items.length - 1;
    }

    final newState = ListenState(
      items: _items,
      currentIndex: currentIndex,
    );

    emitter(newState);
  }

  void _onCustom(error) {
    debugPrint("MainBloc._onCustom(error), error = $error");
    add(ListenEvent(isScheduleLoaded: false, loadingError: error));
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
      add(ListenEvent(isScheduleLoaded: true, mediaItems: queue));
    }
  }

  @override
  Future<void> close() {
    debugPrint("MainBloc.close()");
    _customSubscription.cancel();
    _queueSubscription.cancel();
    return super.close();
  }
}
