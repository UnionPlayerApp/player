import 'package:intl/intl.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';

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
    this.start = _formatDateTime(itemRaw.start);
    this.finish = _formatDateTime(itemRaw.start.add(itemRaw.duration));
    this.duration = _formatDuration(itemRaw.duration);
    this.title = itemRaw.title;
    this.artist = itemRaw.artist;
    this.description = itemRaw.description;
    this.guest = itemRaw.guest;
    this.imageUrl = itemRaw.imageUrl;
  }

  //TODO: сделать "вчера / завтра / дата"
  String _formatDateTime(DateTime dateTime) {
    final pattern = _isToday(dateTime) ? "HH:mm" : "d.m HH:mm";
    return DateFormat(pattern).format(dateTime);
  }

  bool _isToday(DateTime dateTime) {
    final now = DateTime.now();
    return now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.compareTo(Duration(hours: 1)) < 0
        ? "$twoDigitMinutes:$twoDigitSeconds"
        : "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}