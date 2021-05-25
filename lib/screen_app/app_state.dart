part of 'app_bloc.dart';

class AppState extends Equatable {
  final int navIndex;
  final bool playingState;
  final AudioProcessingState processingState;
  final String presentTitle;
  final String presentArtist;
  final String nextTitle;
  final String nextArtist;
  final bool isScheduleLoaded;

  const AppState(this.navIndex, this.playingState, this.processingState,
      {this.isScheduleLoaded = false,
      this.presentTitle = "",
      this.presentArtist = "",
      this.nextTitle = "",
      this.nextArtist = ""});

  @override
  List<Object> get props => [
        navIndex,
        playingState,
        processingState,
        isScheduleLoaded,
        presentTitle,
        presentArtist,
        nextTitle,
        nextArtist
      ];
}
