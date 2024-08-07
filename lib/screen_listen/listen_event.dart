import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';

import '../common/enums/sound_quality_type.dart';

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

class ListenSoundQualityEvent extends ListenEvent {
  final SoundQualityType soundQualityType;

  const ListenSoundQualityEvent({required this.soundQualityType});

  @override
  List<Object?> get props => [soundQualityType];
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
