part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {}

class AppFabPressedEvent extends AppEvent {
  @override
  List<Object?> get props => [];
}

class AppNavPressedEvent extends AppEvent {
  final int navIndex;

  AppNavPressedEvent(this.navIndex);

  @override
  List<Object> get props => [navIndex];
}

class AppPlayerStateEvent extends AppEvent {
  final bool playingState;
  final ProcessingState processingState;

  AppPlayerStateEvent(this.playingState, this.processingState);

  @override
  List<Object?> get props => [playingState, processingState];
}
