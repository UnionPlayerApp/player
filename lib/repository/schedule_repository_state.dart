import 'package:union_player_app/repository/schedule_item_raw.dart';

abstract class ScheduleRepositoryState {}

class ScheduleRepositoryLoadSuccessState extends ScheduleRepositoryState {
  final List<ScheduleItemRaw> items;

  ScheduleRepositoryLoadSuccessState(this.items);
}

class ScheduleRepositoryLoadErrorState extends ScheduleRepositoryState {
  final String error;

  ScheduleRepositoryLoadErrorState(this.error);
}