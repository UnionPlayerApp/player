import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:union_player_app/model/program_item.dart';
import 'package:union_player_app/repository/repository.dart';
import 'package:union_player_app/screen_schedule/schedule_event.dart';
import 'package:union_player_app/screen_schedule/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final Repository _repository;
  List<ProgramItem> items = [];

  ScheduleBloc(this._repository) : super(ScheduleInitialState()) {
    add(ScheduleInitialEvent());
  }

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is ScheduleInitialEvent) {
      yield ScheduleInitialState();
      await _fetchProgramList();
      yield ScheduleLoadedState(items);
      return;
    }
  }

  Future _fetchProgramList() async {
    List<ProgramItem> list = await _repository.get();
    items.addAll(list);
  }

}