import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/screen_schedule/schedule_event.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final AudioHandler audioHandler;
  late final StreamSubscription _queueSubscription;
  late final StreamSubscription _customSubscription;

  ScheduleBloc({required this.audioHandler}) : super(ScheduleLoadAwaitState()) {
    on<ScheduleEventDataLoaded>((event, emit) => emit(ScheduleLoadSuccessState(event.items)));
    on<ScheduleEventErrorMade>((event, emit) => emit(ScheduleLoadErrorState(event.error)));

    _queueSubscription = audioHandler.queue.listen(_onQueueEvent);
    _customSubscription = audioHandler.customEvent.listen(_onCustomEvent);
  }

  @override
  Future<void> close() async {
    _queueSubscription.cancel();
    _customSubscription.cancel();
    return super.close();
  }

  void _onQueueEvent(List<MediaItem>? queue) {
    if (queue == null) {
      _onCustomEvent("Unknown error - queue is null");
    } else {
      final items = queue.map((mediaItem) => ScheduleItemView.fromMediaItem(mediaItem)).toList();
      add(ScheduleEventDataLoaded(items));
    }
  }

  void _onCustomEvent(error) => ScheduleEventErrorMade(error);
}
