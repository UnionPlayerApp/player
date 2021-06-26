part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppFabEvent extends AppEvent {}

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

class AppAudioQualitySelectorEvent extends AppEvent {}

class AppAudioQualityButtonEvent extends AppEvent {
  int audioQualityId;

  AppAudioQualityButtonEvent(this.audioQualityId);

  @override
  List<Object?> get props => [audioQualityId];
}
