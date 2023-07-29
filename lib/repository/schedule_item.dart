import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint("start = $start, finish = $finish, now = $now");
    final cond1 = start.isAtSameMomentAs(now);
    final cond2 = start.isBefore(now) && finish.isAfter(now);
    final cond3 = finish.isAtSameMomentAs(now);
    debugPrint("isCurrent = $cond1 || $cond2 || $cond3 => ${cond1 || cond2 || cond3}");
    return start.isAtSameMomentAs(now) || start.isBefore(now) && finish.isAfter(now) || finish.isAtSameMomentAs(now);
  }

  int get millisToFinish {
    final now = DateTime.now();
    return finish.difference(now).inMilliseconds;
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
