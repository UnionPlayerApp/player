import 'package:union_player_app/repository/schedule_item_raw.dart';

class ScheduleItemView {
  final String start;
  final String finish;
  final String duration;
  final String title;
  final String? description;
  final String artist;
  final String? guest;
  final String? imageUrl;

  ScheduleItemView(ScheduleItemRaw itemRaw)
      : this.start = itemRaw.start.toString(),
        this.finish = (itemRaw.start.add(itemRaw.duration)).toString(),
        this.duration = itemRaw.duration.toString(),
        this.title = itemRaw.title,
        this.artist = itemRaw.artist,
        this.description = itemRaw.description,
        this.guest = itemRaw.guest,
        this.imageUrl = itemRaw.imageUrl;
}
