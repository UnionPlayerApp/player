import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:union_player_app/common/core/file_utils.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_repository_event.dart';
import 'package:union_player_app/repository/schedule_repository_interface.dart';
import 'package:xml/xml.dart';

import '../common/core/date_time.dart';
import '../common/core/debug.dart';
import '../common/core/duration.dart';
import 'schedule_item_type.dart';

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
    while (_isOpen) {
      ScheduleRepositoryEvent state;
      int attempt = 1;

      do {
        debugPrint("schedule stream() => attempt = $attempt");

        if (attempt > 1) {
          debugPrint("schedule stream() => delay for 1 second start");
          await Future.delayed(_delayBetweenAttempts);
          debugPrint("schedule stream() => delay for 1 second finish");
        }

        debugPrint("schedule stream() => _load() start, attempt = $attempt");
        state = await _load(url);
        debugPrint("schedule stream() => _load() finish, attempt = $attempt");

        debugPrint("schedule stream() => state is $state");
      } while (state is ScheduleRepositoryErrorEvent && attempt++ < _attemptMax);

      debugPrint("schedule stream() => exit from circle");

      _subject.add(state);

      final millis = _millisToNextLoad();

      final minutes = millis ~/ Duration.millisecondsPerMinute;
      final secondsInMillis = millis % Duration.millisecondsPerMinute;
      final seconds = secondsInMillis ~/ Duration.millisecondsPerSecond;
      final millisRest = secondsInMillis % Duration.millisecondsPerSecond;

      debugPrint("schedule stream() => delay for next load = $millis millis start  => $minutes:$seconds:$millisRest");
      await Future.delayed(Duration(milliseconds: millis));
      debugPrint("schedule stream() => delay for next load = $millis millis finish => $minutes:$seconds:$millisRest");
    }
  }

  int _millisToNextLoad() {
    if (_items.isEmpty) return 1 * Duration.millisecondsPerSecond;

    final currentItem = _currentItem();

    if (currentItem != null) {
      return currentItem.millisToFinish;
    }

    final now = DateTime.now();

    if (now.isBefore(_items.first.start)) {
      return _items.first.start.difference(now).inMilliseconds;
    }

    return 10 * Duration.millisecondsPerSecond;
  }

  ScheduleItem? _currentItem() {
    try {
      return _items.firstWhere((element) => element.isCurrent);
    } catch (_) {
      return null;
    }
  }

  Future<ScheduleRepositoryEvent> _load(String url) async {
    final String scheduleString;
    try {
      scheduleString = await loadRemoteFile(url);
    } catch (error) {
      final msg = "Schedule load error -> Url: $url -> Error: $error";
      debugPrint(msg);
      return ScheduleRepositoryErrorEvent(msg);
    }

    final List<ScheduleItem> loadedItems;
    try {
      loadedItems = _parseScheduleString(scheduleString);
    } catch (error) {
      final msg = "Parse schedule string error -> Url: $url -> Error: $error";
      debugPrint(msg);
      return ScheduleRepositoryErrorEvent(msg);
    }

    if (loadedItems.isNotEmpty) {
      final savedItems = List<ScheduleItem>.empty(growable: true);

      for (var item in _items) {
        if (item.finish.isBefore(loadedItems.first.start)) {
          savedItems.add(item);
        } else {
          break;
        }
      }

      if (savedItems.isNotEmpty) {
        final diffInMillis = loadedItems.first.start.difference(savedItems.last.finish).inMilliseconds ~/ 2;
        savedItems.last.increaseFinish(diffInMillis);
        loadedItems.first.decreaseStart(diffInMillis);
      }

      _items
        ..clear()
        ..addAll(savedItems)
        ..addAll(loadedItems);
    }

    return ScheduleRepositorySuccessEvent(items: _items, currentItem: _currentItem());
  }

  @override
  Future<void> stop() async {
    _isOpen = false;
    await _subject.close();
  }

  List<ScheduleItem> _parseScheduleString(String scheduleString) {
    debugPrint("parseScheduleString()");
    try {
      final document = XmlDocument.parse(scheduleString);
      final elements = document.findAllElements("ELEM");

      if (elements.isEmpty) {
        debugPrint("Scheduler list is empty");
        return const [];
      }

      final newList = List<ScheduleItem>.empty(growable: true);

      var start = _createStart(elements.first);
      if (start == null) {
        debugPrint("No start date time info in the first element of the loaded schedule");
        return const [];
      }

      DateTime finish;

      for (var element in elements) {
        final duration = _createDuration(element);
        if (duration == null) continue;

        finish = start!.add(duration);

        final type = _createType(element);
        if (type == null) continue;

        final title = _createTitle(element);
        final artist = _createArtist(element);

        final item = ScheduleItem(start, finish, duration, type, title, artist, imageUrl: randomUrl());

        newList.add(item);

        start = finish;
      }
      return newList;
    } catch (error) {
      debugPrint("parseScheduleString() => error: $error");
      rethrow;
    }
  }

  ScheduleItemType? _createType(XmlElement element) {
    final eType = element.getElement("TYPE");

    if (eType == null) return null;

    switch (eType.innerText) {
      case "М":
        return ScheduleItemType.music;
      case "П":
        return ScheduleItemType.talk;
      case "Н":
        return ScheduleItemType.news;
      default:
        return null;
    }
  }

  DateTime? _createStart(XmlElement element) {
    final eStartDate = element.getElement("START_DATE");
    final eStartTime = element.getElement("START_TIME");

    if (eStartDate == null || eStartTime == null) return null;

    try {
      return parseDateTime(eStartDate.innerText, eStartTime.innerText);
    } catch (error) {
      debugPrint("Schedule item start date time parsing error: $error");
      return null;
    }
  }

  Duration? _createDuration(XmlElement element) {
    final eDuration = element.getElement("DURATION");
    if (eDuration == null) return null;

    try {
      return parseDuration(eDuration.innerText);
    } catch (error) {
      debugPrint("Schedule item duration parsing error: $error");
      return null;
    }
  }

  String _createArtist(XmlElement element) {
    final eArtist = element.getElement("ARTIST");
    return eArtist == null ? "" : eArtist.innerText;
  }

  String _createTitle(XmlElement element) {
    final eName = element.getElement("NAME");
    return eName == null ? "" : eName.innerText;
  }
}
