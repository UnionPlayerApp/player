import 'package:union_player_app/repository/schedule_item.dart';

abstract class ScheduleRepositoryState {}

class ScheduleRepositoryLoadSuccessState extends ScheduleRepositoryState {
  final List<ScheduleItem> items;

  ScheduleRepositoryLoadSuccessState(this.items);
}

class ScheduleRepositoryLoadErrorState extends ScheduleRepositoryState {
  final String error;

  ScheduleRepositoryLoadErrorState(this.error);
}