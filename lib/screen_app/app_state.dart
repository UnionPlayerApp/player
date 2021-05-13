part of 'app_bloc.dart';

class AppState extends Equatable {
  final int navIndex;
  final bool playingState;
  final ProcessingState processingState;
  final String? title;
  final bool _scheduleLoaded;

  const AppState(this.navIndex, this.playingState, this.processingState,
      {this.title})
      : _scheduleLoaded = title != null;

  @override
  List<Object> get props =>
      [navIndex, playingState, processingState, _scheduleLoaded];
}
