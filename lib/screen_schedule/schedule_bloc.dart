import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/repository/i_schedule_repository.dart';
import 'package:union_player_app/screen_schedule/schedule_event.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final IScheduleRepository _repository;
  ScheduleState scheduleState = ScheduleLoadAwaitState();

  ScheduleBloc(this._repository) : super(ScheduleLoadAwaitState()) {
    add(ScheduleLoadEvent());
  }

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleLoadEvent) {
      yield ScheduleLoadAwaitState();
      await _fetchScheduleList();
      yield scheduleState;
      return;
    }
  }

  Future _fetchScheduleList() async {
    scheduleState = await _repository.getScheduleList();
  }

}