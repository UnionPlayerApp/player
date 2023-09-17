part of 'app_bloc.dart';

class AppState extends Equatable {
  final String nextArtist;
  final String nextTitle;
  final String presentArtist;
  final String presentTitle;
  final bool isAudioQualitySelectorOpen;
  final bool isScheduleLoaded;
  final bool playingState;
  final int audioQualityId;
  final NavType navType;

  const AppState(
    this.navType,
    this.playingState,
    this.audioQualityId,
    this.isAudioQualitySelectorOpen, {
    this.isScheduleLoaded = false,
    this.presentTitle = "",
    this.presentArtist = "",
    this.nextTitle = "",
    this.nextArtist = "",
  });

  @override
  List<Object> get props => [
        audioQualityId,
        isAudioQualitySelectorOpen,
        isScheduleLoaded,
        navType,
        nextArtist,
        nextTitle,
        playingState,
        presentArtist,
        presentTitle,
      ];

  AppState copyWith({
    String? nextArtist,
    String? nextTitle,
    String? presentArtist,
    String? presentTitle,
    bool? isAudioQualitySelectorOpen,
    bool? isScheduleLoaded,
    bool? playingState,
    int? audioQualityId,
    NavType? navType,
  }) =>
      AppState(
        navType ?? this.navType,
        playingState ?? this.playingState,
        audioQualityId ?? this.audioQualityId,
        isAudioQualitySelectorOpen ?? this.isAudioQualitySelectorOpen,
        nextArtist: nextArtist ?? this.nextArtist,
        nextTitle: nextTitle ?? this.nextTitle,
        presentArtist: presentArtist ?? this.presentArtist,
        presentTitle: presentTitle ?? this.presentTitle,
        isScheduleLoaded: isScheduleLoaded ?? this.isScheduleLoaded,
      );
}
