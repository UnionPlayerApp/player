import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:union_player_app/repository/schedule_file.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_repository_event.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';

const _ATTEMPT_MAX = 5;

class ScheduleRepositoryImpl implements IScheduleRepository {
  final _subject = BehaviorSubject<ScheduleRepositoryEvent>(sync: true);
  final _items = List<ScheduleItem>.empty(growable: true);
  bool _isOpen = true;

  @override
  Stream<ScheduleRepositoryEvent> stateStream() => _subject.stream;

  Future<void> start(String url) async {
    log("schedule => start()", name: LOG_TAG);

    while (_isOpen) {
      ScheduleRepositoryEvent state;
      int attempt = 1;

      do {
        if (attempt > 1) {
          log("schedule stream() => delay for 1 second start", name: LOG_TAG);
          await Future.delayed(const Duration(seconds: 1));
          log("schedule stream() => delay for 1 second finish", name: LOG_TAG);
        }

        log("schedule stream() => _load() start, attempt = $attempt", name: LOG_TAG);
        state = await _load(url);
        log("schedule stream() => _load() finish, attempt = $attempt", name: LOG_TAG);
      } while (state is ScheduleRepositoryErrorEvent && attempt++ < _ATTEMPT_MAX);

      _subject.add(state);

      int seconds = _secondsToNextLoad();

      log("schedule stream() => delay for $seconds seconds start", name: LOG_TAG);
      await Future.delayed(Duration(seconds: seconds));
      log("schedule stream() => delay for $seconds seconds finish", name: LOG_TAG);
    }
  }

  int _secondsToNextLoad() {
    if (_items.isEmpty) return 1;

    final currentElement = _items[0];
    final finish = currentElement.start.add(currentElement.duration);
    final now = DateTime.now();
    final rest = finish.difference(now).inSeconds;

    log("schedule -> current start     = ${currentElement.start}", name: LOG_TAG);
    log("schedule -> current finish    = $finish", name: LOG_TAG);
    log("schedule -> current duration  = ${currentElement.duration}", name: LOG_TAG);
    log("schedule -> now               = $now", name: LOG_TAG);
    log("schedule -> rest to next load = ${rest > 0 ? rest : 1}", name: LOG_TAG);

    return rest > 0 ? rest : 1;
  }

  Future<ScheduleRepositoryEvent> _load(String url) async {
    late final File file;
    late final List<ScheduleItem> newItems;

    _items.clear();

    try {
      file = await loadRemoteFile(url);
      log("Schedule file load success -> File: $file", name: LOG_TAG);
    } catch (error) {
      final msg = "Schedule file load error -> Url: $url -> Error: $error";
      log(msg, name: LOG_TAG);
      return ScheduleRepositoryErrorEvent(msg);
    }

    try {
      newItems = parseScheduleFile(file);
    } catch (error) {
      final msg = "Parse schedule file error -> Path: $file -> Error: $error";
      log(msg, name: LOG_TAG);
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
