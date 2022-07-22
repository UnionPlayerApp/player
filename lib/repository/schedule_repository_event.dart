import 'package:union_player_app/repository/schedule_item.dart';

abstract class ScheduleRepositoryEvent {}

class ScheduleRepositorySuccessEvent extends ScheduleRepositoryEvent {
  final List<ScheduleItem> items;

  ScheduleRepositorySuccessEvent(this.items);
}

class ScheduleRepositoryErrorEvent extends ScheduleRepositoryEvent {
  final String error;

  ScheduleRepositoryErrorEvent(this.error);
}