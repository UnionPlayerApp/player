part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppFabPlayStopEvent extends AppEvent {}

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
  final int audioQualityId;

  AppAudioQualityButtonEvent(this.audioQualityId);

  @override
  List<Object?> get props => [audioQualityId];
}

class AppAudioQualityInitEvent extends AppEvent {
  final int audioQualityId;

  AppAudioQualityInitEvent(this.audioQualityId);

  @override
  List<Object?> get props => [audioQualityId];
}
