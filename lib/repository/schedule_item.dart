import 'package:equatable/equatable.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';

import '../utils/core/date_time.dart';

// ignore: must_be_immutable
class ScheduleItem extends Equatable {
  DateTime start;
  DateTime finish;
  Duration duration;
  final ScheduleItemType type;
  final String title;
  final String? description;
  final String artist;
  final String? imageUrl;

  ScheduleItem(this.start, this.finish, this.duration, this.type, this.title, this.artist,
      {this.description, this.imageUrl});

  factory ScheduleItem.empty() => ScheduleItem(
        DateTime(0),
        DateTime(0),
        Duration.zero,
        ScheduleItemType.indefinite,
        "",
        "",
      );

  bool get isCurrent {
    final now = DateTime.now();
    return start.isAtSameMomentAs(now) || start.isBefore(now) && finish.isAfter(now) || finish.isAtSameMomentAs(now);
  }

  int get secondsToFinish {
    final now = DateTime.now();
    return finish.difference(now).inSeconds;
  }

  @override
  String toString() => "ScheduleItem, "
      "start = ${formatDateTime(start)} = ${start.millisecondsSinceEpoch}, "
      "finish = ${formatDateTime(finish)} = ${finish.millisecondsSinceEpoch}, "
      "title = $title";

  @override
  List<Object?> get props => [start.millisecondsSinceEpoch, finish.millisecondsSinceEpoch];

  void decreaseStart(int diffInMillis) {
    start = start.subtract(Duration(milliseconds: diffInMillis));
    duration = finish.difference(start);
  }

  void increaseFinish(int diffInMillis) {
    finish = finish.add(Duration(milliseconds: diffInMillis));
    duration = finish.difference(start);
  }
}
