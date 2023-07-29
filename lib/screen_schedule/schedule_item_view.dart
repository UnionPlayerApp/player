import 'package:audio_service/audio_service.dart';
import 'package:union_player_app/player/app_player_handler.dart';
import 'package:union_player_app/utils/core/date_time.dart';
import 'package:union_player_app/utils/core/duration.dart';

class ScheduleItemView {
  final String artist;
  final String duration;
  final String finish;
  final String start;
  final String title;
  final String? description;
  final Uri? imageUri;

  ScheduleItemView._({
    required this.artist,
    required this.duration,
    required this.finish,
    required this.start,
    required this.title,
    required this.description,
    required this.imageUri,
  });

  factory ScheduleItemView.fromMediaItem(MediaItem item) => ScheduleItemView._(
        artist: item.artist ?? "",
        description: item.displayDescription,
        duration: formatDuration(item.duration!),
        finish: formatDateTime(item.start.add(item.duration!)),
        imageUri: item.artUri,
        start: formatDateTime(item.start),
        title: item.title,
      );
}
