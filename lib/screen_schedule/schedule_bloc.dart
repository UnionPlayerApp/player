import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/screen_schedule/schedule_event.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';
import 'package:union_player_app/utils/app_logger.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final IScheduleRepository _repository;
  final AppLogger _logger;
  late StreamSubscription _subscription;

  ScheduleBloc(this._repository, this._logger)
      : super(ScheduleLoadAwaitState()) {
    _subscription = _repository.stream().listen((event) => onData(event));
  }

  @override
  Future<void> close() async {
    _subscription.cancel();
    return super.close();
  }

  void onData(ScheduleRepositoryState state) {
    if (state is ScheduleRepositoryLoadSuccessState) {
      final items =
          state.items.map((itemRaw) => ScheduleItemView(itemRaw)).toList();
      add(ScheduleEventDataLoaded(items));
    }

    if (state is ScheduleRepositoryLoadErrorState) {
      add(ScheduleEventErrorMade(state.error));
    }
  }

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
