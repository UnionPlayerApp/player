import 'dart:async';
import 'dart:io';
import 'package:union_player_app/model/system_data/system_data.dart';
import 'package:union_player_app/repository/schedule_file.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_repository_state.dart';
import 'package:union_player_app/utils/app_logger.dart';

class ScheduleRepositoryImpl implements IScheduleRepository {
  final AppLogger _logger;
  final SystemData _systemData;

  ScheduleRepositoryImpl(this._logger, this._systemData);

  bool _isOpen = true;

  List<ScheduleItemRaw> _items = List.empty(growable: true);

  @override
  List<ScheduleItemRaw> getItems() => _items;

  @override
  ScheduleItemRaw? getCurrentItem() {
    return _firstItemIsCurrent() ? _items[0] : null;
  }

  @override
  Stream<ScheduleRepositoryState> stream() async* {
    while (_isOpen) {
      final seconds = _secondsToCurrentFinish();

      if (seconds < 0) {
        yield await _load();
      } else {
        await Future.delayed(Duration(seconds: seconds));
      }
    }
  }

  bool _firstItemIsCurrent() => (_secondsToCurrentFinish() >= 0);

  int _secondsToCurrentFinish() {
    if (_items.isEmpty) return -1;

    final current = _items[0];
    final finish = current.start.add(current.duration);
    final now = DateTime.now();

    return finish.difference(now).inSeconds;
  }

  Future<ScheduleRepositoryState> _load() async {
    late File file;
    late List<ScheduleItemRaw> newItems;

    _items.clear();

    try {
      file = await loadScheduleFile(_systemData.xmlData.url);
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
  }
}
