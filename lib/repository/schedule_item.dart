import 'package:union_player_app/repository/schedule_item_type.dart';

class ScheduleItem {
  final DateTime start;
  final Duration duration;
  final ScheduleItemType type;
  final String title;
  final String? description;
  final String artist;
  final String? imageUrl;

  ScheduleItem(this.start, this.duration, this.type, this.title, this.artist,
      {this.description, this.imageUrl});
}