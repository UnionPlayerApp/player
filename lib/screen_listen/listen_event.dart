import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';

import '../utils/enums/audio_quality_type.dart';

abstract class ListenEvent extends Equatable {
  const ListenEvent();
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
  final AudioQualityType audioQualityType;

  const ListenAudioQualityEvent({required this.audioQualityType});

  @override
  List<Object?> get props => [audioQualityType];
}

class ListenInitEvent extends ListenEvent {
  @override
  List<Object?> get props => [];
}
