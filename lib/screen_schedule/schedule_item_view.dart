import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/utils/core/date_time.dart';
import 'package:union_player_app/utils/core/duration.dart';

class ScheduleItemView {
  String start = "";
  String finish = "";
  String duration = "";
  String title = "";
  String? description;
  String artist = "";
  String? guest;
  String? imageUrl;

  ScheduleItemView(ScheduleItemRaw itemRaw) {
    this.start = formatDateTime(itemRaw.start);
    this.finish = formatDateTime(itemRaw.start.add(itemRaw.duration));
    this.duration = formatDuration(itemRaw.duration);
    this.title = itemRaw.title;
    this.artist = itemRaw.artist;
    this.description = itemRaw.description;
    this.guest = itemRaw.guest;
    this.imageUrl = itemRaw.imageUrl;
  }
}