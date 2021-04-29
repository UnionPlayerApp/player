import 'package:equatable/equatable.dart';
import 'package:union_player_app/model/program_item.dart';

abstract class ScheduleState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleInitialState extends ScheduleState {}

class ScheduleLoadedState extends ScheduleState {
  final List<ProgramItem> items;

  ScheduleLoadedState(this.items);

  @override
  List<Object> get props => [items];

}