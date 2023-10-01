import 'package:audio_service/audio_service.dart';
import 'package:union_player_app/player/app_player_handler.dart';
import 'package:union_player_app/common/core/date_time_ui_model.dart';
import 'package:union_player_app/common/core/duration.dart';

import '../common/enums/relative_time_type.dart';

class ScheduleItemView {
  final String artist;
  final String duration;
  final DateTimeUiModel finish;
  final DateTimeUiModel start;
  final String title;
  final String? description;
  final Uri? imageUri;
  final RelativeTimeType timeType;

  ScheduleItemView._({
    required this.artist,
    required this.duration,
    required this.finish,
    required this.start,
    required this.title,
    required this.description,
    required this.imageUri,
    required this.timeType,
  });

  factory ScheduleItemView.fromMediaItem(MediaItem item) {
    final finish = item.start.add(item.duration!);
    final timeType = relativeTimeType(item.start, finish);

    return ScheduleItemView._(
      artist: item.artist ?? "",
      description: item.displayDescription,
      duration: formatDuration(item.duration!),
      finish: DateTimeUiModel.fromDateTime(finish),
      imageUri: item.artUri,
      start: DateTimeUiModel.fromDateTime(item.start),
      title: item.title,
      timeType: timeType
    );
  }
}
