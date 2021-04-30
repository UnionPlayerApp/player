part of 'app_bloc.dart';

class AppState extends Equatable {
  final int navIndex;
  final bool playingState;
  final ProcessingState processingState;

  const AppState(this.navIndex, this.playingState, this.processingState);

  @override
  List<Object> get props => [navIndex, playingState, processingState];
}
