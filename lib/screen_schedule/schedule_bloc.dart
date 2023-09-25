import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_event.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';
import 'package:union_player_app/utils/enums/relative_time_type.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final AudioHandler audioHandler;
  late final StreamSubscription _queueSubscription;
  late final StreamSubscription _customSubscription;

  ScheduleBloc({required this.audioHandler}) : super(const ScheduleLoadingState()) {
    on<ScheduleEventDataLoaded>(_onDataLoaded);
    on<ScheduleEventErrorMade>(_onErrorMade);

    _queueSubscription = audioHandler.queue.listen(_onQueueEvent);
    _customSubscription = audioHandler.customEvent.listen(_onCustomEvent);
  }

  FutureOr<void> _onDataLoaded(ScheduleEventDataLoaded event, Emitter<ScheduleState> emitter) {
    emitter(ScheduleLoadedState(items: event.items, currentIndex: event.currentIndex));
  }

  FutureOr<void> _onErrorMade(ScheduleEventErrorMade event, Emitter<ScheduleState> emitter) {
    emitter(state.copyWithError(errorText: event.error));
  }

  @override
  Future<void> close() async {
    _queueSubscription.cancel();
    _customSubscription.cancel();
    return super.close();
  }

  void _onQueueEvent(List<MediaItem>? queue) {
    if (queue == null) {
      _onCustomEvent("Schedule load error: queue is null");
    } else if (queue.isEmpty) {
      _onCustomEvent("Schedule load error: queue is empty");
    } else {
      final items = queue.map((mediaItem) => ScheduleItemView.fromMediaItem(mediaItem)).toList();
      final currentIndex = _currentIndex(items);
      add(ScheduleEventDataLoaded(items: items, currentIndex: currentIndex));
    }
  }

  void _onCustomEvent(error) => add(ScheduleEventErrorMade(error));

  int _currentIndex(List<ScheduleItemView> items) {
    if (items.isEmpty) {
      return -1;
    }

    try {
      final currentItem = items.firstWhere((item) => item.timeType.isCurrent);
      return items.indexOf(currentItem);
    } on StateError catch (_) {
      if (items.first.timeType.isNext) {
        return 0;
      }

      if (items.last.timeType.isPrevious) {
        return items.length - 1;
      }

      return -1;
    }
  }
}
