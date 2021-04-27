import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class UserPressEvent extends MainEvent {}

class PlayPauseFabPressed extends UserPressEvent {}

abstract class PlayerStateChangedEvent extends MainEvent {
   final bool isPlaying;

   PlayerStateChangedEvent(this.isPlaying);

   @override
   List<Object?> get props => [isPlaying];
}

class PlayerStateChangedToBuffering extends PlayerStateChangedEvent {
  PlayerStateChangedToBuffering(bool isPlaying) : super(isPlaying);
}

class PlayerStateChangedToCompleted extends PlayerStateChangedEvent {
  PlayerStateChangedToCompleted(bool isPlaying) : super(isPlaying);
}

class PlayerStateChangedToIdle extends PlayerStateChangedEvent {
  PlayerStateChangedToIdle(bool isPlaying) : super(isPlaying);
}

class PlayerStateChangedToLoading extends PlayerStateChangedEvent {
  PlayerStateChangedToLoading(bool isPlaying) : super(isPlaying);
}

class PlayerStateChangedToReady extends PlayerStateChangedEvent {
  PlayerStateChangedToReady(bool isPlaying) : super(isPlaying);
}
