import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:union_player_app/repository/schedule_file.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_repository_event.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/utils/core/file_utils.dart';

class ScheduleRepositoryImpl implements IScheduleRepository {
  static const _attemptMax = 5;
  static const _delayBetweenAttempts = Duration(seconds: 1);

  final _subject = BehaviorSubject<ScheduleRepositoryEvent>(sync: true);
  final _items = List<ScheduleItem>.empty(growable: true);

  bool _isOpen = true;

  @override
  Stream<ScheduleRepositoryEvent> stateStream() => _subject.stream;

  @override
  Future<void> start(String url) async {
    debugPrint("schedule => start()");

    while (_isOpen) {
      ScheduleRepositoryEvent state;
      int attempt = 1;

      do {
        if (attempt > 1) {
          debugPrint("schedule stream() => delay for 1 second start");
          await Future.delayed(_delayBetweenAttempts);
          debugPrint("schedule stream() => delay for 1 second finish");
        }

        debugPrint("schedule stream() => _load() start, attempt = $attempt");
        state = await _load(url);
        debugPrint("schedule stream() => _load() finish, attempt = $attempt");
      } while (state is ScheduleRepositoryErrorEvent && attempt++ < _attemptMax);

      _subject.add(state);

      int seconds = _secondsToNextLoad();

      debugPrint("schedule stream() => delay for $seconds seconds start");
      await Future.delayed(Duration(seconds: seconds));
      debugPrint("schedule stream() => delay for $seconds seconds finish");
    }
  }

  int _secondsToNextLoad() {
    if (_items.isEmpty) return 1;

    final currentElement = _items[0];
    final finish = currentElement.start.add(currentElement.duration);
    final now = DateTime.now();
    final rest = finish.difference(now).inSeconds;

    debugPrint("schedule -> current start     = ${currentElement.start}");
    debugPrint("schedule -> current finish    = $finish");
    debugPrint("schedule -> current duration  = ${currentElement.duration}");
    debugPrint("schedule -> now               = $now");
    debugPrint("schedule -> rest to next load = ${rest > 0 ? rest : 1}");

    return rest > 0 ? rest : 1;
  }

  Future<ScheduleRepositoryEvent> _load(String url) async {
    late final String scheduleString;
    late final List<ScheduleItem> newItems;

    _items.clear();

    try {
      scheduleString = await loadRemoteFile(url);
      debugPrint("Schedule load success -> Url: $url");
    } catch (error) {
      final msg = "Schedule load error -> Url: $url -> Error: $error";
      debugPrint(msg);
      return ScheduleRepositoryErrorEvent(msg);
    }

    try {
      newItems = parseScheduleString(scheduleString);
    } catch (error) {
      final msg = "Parse schedule string error -> Url: $url -> Error: $error";
      debugPrint(msg);
      return ScheduleRepositoryErrorEvent(msg);
    }

    _items.addAll(newItems);

    return ScheduleRepositorySuccessEvent(_items);
  }

  @override
  Future<void> stop() async {
    _isOpen = false;
    await _subject.close();
  }
}
