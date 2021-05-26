import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/screen_schedule/schedule_event.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';
import 'package:union_player_app/utils/app_logger.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final AppLogger _logger;
  late final StreamSubscription _queueSubscription;
  late final StreamSubscription _customSubscription;

  ScheduleBloc(this._logger)
      : super(ScheduleLoadAwaitState()) {
    _queueSubscription = AudioService.queueStream.listen((queue) => _onQueue(queue));
    _customSubscription = AudioService.customEventStream.listen((error) => _onCustom(error));
    //_subscription = _repository.stream().listen((event) => onData(event));
  }

  @override
  Future<void> close() async {
    _queueSubscription.cancel();
    _customSubscription.cancel();
    return super.close();
  }

  void _onQueue(List<MediaItem>? queue) {
    if (queue == null) {
      _onCustom("Unknown error - empty queue");
    } else {
      final items = queue.map((mediaItem) => ScheduleItemView(mediaItem)).toList();
      add(ScheduleEventDataLoaded(items));
    }
  }

  void _onCustom(error) => ScheduleEventErrorMade(error);

  // void onData(ScheduleRepositoryState state) {
  //   if (state is ScheduleRepositoryLoadSuccessState) {
  //     final items =
  //         state.items.map((itemRaw) => ScheduleItemView(itemRaw)).toList();
  //     add(ScheduleEventDataLoaded(items));
  //   }
  //
  //   if (state is ScheduleRepositoryLoadErrorState) {
  //     add(ScheduleEventErrorMade(state.error));
  //   }
  // }

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleEventDataLoaded) {
      yield ScheduleLoadSuccessState(event.items);
    }

    if (event is ScheduleEventErrorMade) {
      yield ScheduleLoadErrorState(event.error);
    }
  }
}
