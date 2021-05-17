import 'package:union_player_app/repository/schedule_item_type.dart';

class ScheduleItemRaw {
  final DateTime start;
  final Duration duration;
  final ScheduleItemType type;
  final String title;
  final String? description;
  final String artist;
  final String? guest;
  final String? imageUrl;

  ScheduleItemRaw(this.start, this.duration, this.type, this.title, this.artist,
      {this.description, this.guest, this.imageUrl});
}