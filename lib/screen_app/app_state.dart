part of 'app_bloc.dart';

class AppState extends Equatable {
  final int navIndex;
  final bool playingState;
  final ProcessingState processingState;
  final String? presentTitle;
  final String? presentArtist;
  final String? nextTitle;
  final String? nextArtist;
  final bool scheduleLoaded;

  const AppState(this.navIndex, this.playingState, this.processingState,
      {this.presentTitle, this.presentArtist, this.nextTitle, this.nextArtist})
      : scheduleLoaded = presentTitle != null &&
            presentArtist != null &&
            nextTitle != null &&
            nextArtist != null;

  @override
  List<Object> get props =>
      [navIndex, playingState, processingState, scheduleLoaded];
}
