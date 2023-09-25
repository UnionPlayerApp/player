import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';

import '../utils/enums/sound_quality_type.dart';

abstract class ListenEvent extends Equatable {
  const ListenEvent();

  @override
  List<Object?> get props => [];
}

class ListenLoadEvent extends ListenEvent {
  final bool isScheduleLoaded;
  final List<MediaItem> mediaItems;
  final String loadingError;

  const ListenLoadEvent({
    required this.isScheduleLoaded,
    this.mediaItems = const [],
    this.loadingError = "",
  });

  @override
  List<Object?> get props => [isScheduleLoaded, mediaItems, loadingError];
}

class ListenAudioQualityEvent extends ListenEvent {
  final SoundQualityType audioQualityType;

  const ListenAudioQualityEvent({required this.audioQualityType});

  @override
  List<Object?> get props => [audioQualityType];
}

class ListenInitEvent extends ListenEvent {}

class ListenPlayerButtonEvent extends ListenEvent {}

class ListenBackStepEvent extends ListenEvent {}

class ListenForwardStepEvent extends ListenEvent {}

class ListenPlaybackEvent extends ListenEvent {
  final PlaybackState playbackState;

  const ListenPlaybackEvent({required this.playbackState});

  @override
  List<Object?> get props => [playbackState];
}
