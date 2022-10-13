import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:union_player_app/repository/schedule_file.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_repository_event.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/utils/core/file_utils.dart';

const _ATTEMPT_MAX = 5;

class ScheduleRepositoryImpl implements IScheduleRepository {
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
          await Future.delayed(const Duration(seconds: 1));
          debugPrint("schedule stream() => delay for 1 second finish");
        }

        debugPrint("schedule stream() => _load() start, attempt = $attempt");
        state = await _load(url);
        debugPrint("schedule stream() => _load() finish, attempt = $attempt");
      } while (state is ScheduleRepositoryErrorEvent && attempt++ < _ATTEMPT_MAX);

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
    late final File file;
    late final List<ScheduleItem> newItems;

    _items.clear();

    try {
      file = await loadRemoteFile(url);
      debugPrint("Schedule file load success -> File: $file");
    } catch (error) {
      final msg = "Schedule file load error -> Url: $url -> Error: $error";
      debugPrint(msg);
      return ScheduleRepositoryErrorEvent(msg);
    }

    try {
      newItems = parseScheduleFile(file);
    } catch (error) {
      final msg = "Parse schedule file error -> Path: $file -> Error: $error";
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
