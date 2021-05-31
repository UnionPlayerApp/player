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

  AppPlayerEvent(this.playingState);

  @override
  List<Object?> get props => [playingState];
}

class AppScheduleEvent extends AppEvent {
  final List<MediaItem>? items;

  AppScheduleEvent(this.items);

  @override
  List<Object?> get props => [items];
}
