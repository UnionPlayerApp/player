import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScheduleLoadEvent extends ScheduleEvent {}

