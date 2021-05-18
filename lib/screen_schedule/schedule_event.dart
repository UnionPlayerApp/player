import 'package:equatable/equatable.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';

abstract class ScheduleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScheduleEventDataLoaded extends ScheduleEvent {
  final List<ScheduleItemView> items;

  ScheduleEventDataLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ScheduleEventErrorMade extends ScheduleEvent {
  final String error;

  ScheduleEventErrorMade(this.error);

  @override
  List<Object?> get props => [error];
}

