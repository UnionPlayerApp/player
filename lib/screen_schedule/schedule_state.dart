import 'package:equatable/equatable.dart';
import 'package:union_player_app/screen_schedule/schedule_item_view.dart';

abstract class ScheduleState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleLoadAwaitState extends ScheduleState {}

class ScheduleLoadSuccessState extends ScheduleState {
  final List<ScheduleItemView> items;

  ScheduleLoadSuccessState(this.items);

  @override
  List<Object> get props => [items];
}

class ScheduleLoadErrorState extends ScheduleState {
  final String errorMessage;

  ScheduleLoadErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ScheduleLoadUnknownState extends ScheduleState {}