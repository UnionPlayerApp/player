import 'package:audio_service/audio_service.dart';
import 'package:equatable/equatable.dart';

class ListenEvent extends Equatable {
  final bool isScheduleLoaded;
  final List<MediaItem> mediaItems;
  final String loadingError;

  const ListenEvent({
    required this.isScheduleLoaded,
    this.mediaItems = const [],
    this.loadingError = "",
  });

  @override
  List<Object?> get props => [isScheduleLoaded, mediaItems, loadingError];
}
