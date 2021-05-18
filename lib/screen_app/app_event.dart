part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {}

class AppFabEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class AppNavEvent extends AppEvent {
  final int navIndex;

  AppNavEvent(this.navIndex);

  @override
  List<Object> get props => [navIndex];
}

class AppPlayerEvent extends AppEvent {
  final bool playingState;
  final ProcessingState processingState;

  AppPlayerEvent(this.playingState, this.processingState);

  @override
  List<Object?> get props => [playingState, processingState];
}

class AppScheduleEvent extends AppEvent {
  final List<ScheduleItemRaw>? items;

  AppScheduleEvent(this.items);

  @override
  List<Object?> get props => [items];
}
