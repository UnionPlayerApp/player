import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:union_player_app/repository/schedule_file.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';

const _ATTEMPT_MAX = 5;

class ScheduleRepositoryImpl implements IScheduleRepository {
  final _subject = BehaviorSubject<ScheduleRepositoryState>(sync: true);
  final _items = List<ScheduleItem>.empty(growable: true);
  bool _isOpen = true;

  @override
  Stream<ScheduleRepositoryState> stateStream() => _subject.stream;

  void onStart(String url) async {
    log("schedule repository => onStart()", name: LOG_TAG);

    while (_isOpen) {
      ScheduleRepositoryState state;
      int attempt = 1;

      do {
        if (attempt > 1) {
          log("schedule repository stream() => delay for 1 second start", name: LOG_TAG);
          await Future.delayed(const Duration(seconds: 1));
          log("schedule repository stream() => delay for 1 second finish", name: LOG_TAG);
        }

        log("schedule repository stream() => _load() start, attempt = $attempt", name: LOG_TAG);
        state = await _load(url);
        log("schedule repository stream() => _load() finish, attempt = $attempt", name: LOG_TAG);
      } while (state is ScheduleRepositoryLoadErrorState && attempt++ < _ATTEMPT_MAX);

      _subject.add(state);

      int seconds = _secondsToNextLoad();

      log("schedule repository stream() => delay for $seconds seconds start", name: LOG_TAG);
      await Future.delayed(Duration(seconds: seconds));
      log("schedule repository stream() => delay for $seconds seconds finish", name: LOG_TAG);
    }
  }

  int _secondsToNextLoad() {
    if (_items.isEmpty) return 1;

    final currentElement = _items[0];
    final finish = currentElement.start.add(currentElement.duration);
    final now = DateTime.now();
    final rest = finish.difference(now).inSeconds;

    log("schedule repository -> current start     = ${currentElement.start}", name: LOG_TAG);
    log("schedule repository -> current finish    = $finish", name: LOG_TAG);
    log("schedule repository -> current duration  = ${currentElement.duration}", name: LOG_TAG);
    log("schedule repository -> now               = $now", name: LOG_TAG);
    log("schedule repository -> rest to next load = ${rest > 0 ? rest : 1}", name: LOG_TAG);

    return rest > 0 ? rest : 1;
  }

  Future<ScheduleRepositoryState> _load(String url) async {
    late final File file;
    late final List<ScheduleItem> newItems;

    _items.clear();

    try {
      file = await loadRemoteFile(url);
      log("Schedule file load success -> File: $file", name: LOG_TAG);
    } catch (error) {
      final msg = "Schedule file load error -> Url: $url -> Error: $error";
      log(msg, name: LOG_TAG);
      return ScheduleRepositoryLoadErrorState(msg);
    }

    try {
      newItems = parseScheduleFile(file);
    } catch (error) {
      final msg = "Parse schedule file error -> Path: $file -> Error: $error";
      log(msg, name: LOG_TAG);
      return ScheduleRepositoryLoadErrorState(msg);
    }

    _items.addAll(newItems);

    return ScheduleRepositoryLoadSuccessState(_items);
  }

  @override
  Future<void> onStop() async {
    _isOpen = false;
    await _subject.close();
  }
}
