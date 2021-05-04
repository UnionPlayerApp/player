import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/repository/i_schedule_repository.dart';
import 'package:union_player_app/screen_schedule/schedule_event.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';
import 'package:union_player_app/utils/app_logger.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final IScheduleRepository _repository;
  final AppLogger _logger;

  ScheduleBloc(this._repository, this._logger) : super(ScheduleLoadAwaitState()) {
    add(ScheduleLoadEvent());
  }

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleLoadEvent) {
      _logger.logDebug("schedule loading...");
      yield ScheduleLoadAwaitState();
      yield await _fetchScheduleList();
      _logger.logDebug("schedule loading completed");
    }
  }

  Future<ScheduleState> _fetchScheduleList() async {
      return await _repository.getScheduleList();
  }
}
