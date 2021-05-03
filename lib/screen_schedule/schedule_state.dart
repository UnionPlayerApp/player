import 'package:equatable/equatable.dart';
import 'package:union_player_app/model/schedule_item.dart';

abstract class ScheduleState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleLoadAwaitState extends ScheduleState {}

class ScheduleLoadSuccessState extends ScheduleState {
  final List<ScheduleItem> items;

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