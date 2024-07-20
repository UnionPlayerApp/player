import 'package:union_player_app/repository/schedule_item.dart';

abstract class ScheduleRepositoryEvent {
  const ScheduleRepositoryEvent();
}

class ScheduleRepositorySuccessEvent extends ScheduleRepositoryEvent {
  final List<ScheduleItem> items;
  final ScheduleItem? currentItem;

  const ScheduleRepositorySuccessEvent({required this.items, required this.currentItem});
}

class ScheduleRepositoryErrorEvent extends ScheduleRepositoryEvent {
  final String error;

  const ScheduleRepositoryErrorEvent(this.error);
}