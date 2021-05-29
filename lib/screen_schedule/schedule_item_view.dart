import 'package:audio_service/audio_service.dart';
import 'package:union_player_app/utils/core/date_time.dart';
import 'package:union_player_app/utils/core/duration.dart';

class ScheduleItemView {
  String artist = "";
  String duration = "";
  String finish = "";
  String start = "";
  String title = "";
  String? description;
  String? guest;
  Uri? imageUri;

  ScheduleItemView(MediaItem item) {
    this.artist = item.artist ?? "";
    this.description = item.displayDescription;
    this.duration = formatDuration(item.duration!);
    this.finish = formatDateTime(item.start.add(item.duration!));
    this.guest = item.guest;
    this.imageUri = item.artUri;
    this.start = formatDateTime(item.start);
    this.title = item.title;
  }
}

extension _MediaItemExtension on MediaItem {

  DateTime get start => DateTime.fromMicrosecondsSinceEpoch(this.extras!["start"]);
  String get guest => this.extras!["guest"];
}