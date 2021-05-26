import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/repository/schedule_file.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/app_logger.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/file_utils.dart';

const _ATTEMPT_MAX = 5;

class ScheduleRepositoryImpl implements IScheduleRepository {
  final AppLogger _logger;
  final SystemData _systemData;
  final _subject = BehaviorSubject<ScheduleRepositoryState>(sync: true);
  final _items = List<ScheduleItemRaw>.empty(growable: true);
  bool _isOpen = true;

  ScheduleRepositoryImpl(this._logger, this._systemData) {
    startStream();
  }

  @override
  List<ScheduleItemRaw> getItems() => _items;

  @override
  ScheduleItemRaw? getCurrentItem() {
    return _firstItemIsCurrent() ? _items[0] : null;
  }

  @override
  Stream<ScheduleRepositoryState> stream() => _subject.stream;

  void startStream() async {
    log("schedule repository ($this) stream() => start", name: LOG_TAG);

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
        state  = await _load();
        log("schedule repository stream() => _load() finish, attempt = $attempt", name: LOG_TAG);
      } while (state is ScheduleRepositoryLoadErrorState && attempt++ < _ATTEMPT_MAX);

      _subject.add(state);

      int seconds = _secondsToNextLoad();

      log("schedule repository stream() => delay for $seconds seconds start", name: LOG_TAG);
      await Future.delayed(Duration(seconds: seconds));
      log("schedule repository stream() => delay for $seconds seconds finish", name: LOG_TAG);
    }
  }

  bool _firstItemIsCurrent() => (_secondsToNextLoad() >= 0);

  int _secondsToNextLoad() {
    if (_items.isEmpty) return 1;

    final currentElement = _items[0];
    final finish = currentElement.start.add(currentElement.duration);
    final now = DateTime.now();
    final rest = finish.difference(now).inSeconds;

    if (rest <= 0) {
      log("rest = $rest", name: LOG_TAG);
      log("start = ${currentElement.start}", name: LOG_TAG);
      log("finish = $finish", name: LOG_TAG);
      log("duration = ${currentElement.duration}", name: LOG_TAG);
      log("now = $now", name: LOG_TAG);
    }

    return (rest > 0) ? rest : 1;
  }

  Future<ScheduleRepositoryState> _load() async {
    late final File file;
    late final List<ScheduleItemRaw> newItems;

    _items.clear();

    try {
      file = await loadRemoteFile(_systemData.xmlData.url);
      _logger.logDebug("Load schedule file success. File = $file");
    } catch (error) {
      final msg = "Load schedule file error. Url = ${_systemData.xmlData.url} ";
      _logger.logError(msg, error);
      return ScheduleRepositoryLoadErrorState("$msg: $error");
    }

    try {
      newItems = parseScheduleFile(file);
    } catch (error) {
      final msg = "Parse schedule file error. Path = $file ";
      _logger.logError(msg, error);
      return ScheduleRepositoryLoadErrorState("$msg: $error");
    }

    _items.addAll(newItems);

    return ScheduleRepositoryLoadSuccessState(_items);
  }

  @override
  void close() {
    _isOpen = false;
    _subject.close();
  }
}
