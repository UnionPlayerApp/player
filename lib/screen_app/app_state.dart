part of 'app_bloc.dart';

class AppState extends Equatable {
  final bool isScheduleLoaded;
  final int navIndex;
  final String nextArtist;
  final String nextTitle;
  final bool playingState;
  final String presentArtist;
  final String presentTitle;

  const AppState(this.navIndex, this.playingState,
      {this.isScheduleLoaded = false,
      this.presentTitle = "",
      this.presentArtist = "",
      this.nextTitle = "",
      this.nextArtist = ""});

  @override
  List<Object> get props => [
        isScheduleLoaded,
        navIndex,
        nextArtist,
        nextTitle,
        playingState,
        presentArtist,
        presentTitle,
      ];
}
