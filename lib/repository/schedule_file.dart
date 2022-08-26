import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/utils/core/date_time.dart';
import 'package:union_player_app/utils/core/debug.dart';
import 'package:union_player_app/utils/core/duration.dart';
import 'package:xml/xml.dart';

List<ScheduleItem> parseScheduleFile(File file) {
  debugPrint("parseScheduleFile()");
  try {
    final document = XmlDocument.parse(file.readAsStringSync());
    final elements = document.findAllElements("ELEM");
    final newList = List<ScheduleItem>.empty(growable: true);

    DateTime start = DateTime.now();

    elements.forEach((element) {
      final type = _createType(element);
      if (type == null) return;

      final duration = _createDuration(element);
      if (duration == null) return;

      final thisStart = _createStart(element, start);
      if (thisStart == null) return;
      start = thisStart.add(duration);

      final title = _createTitle(element);
      final artist = _createArtist(element);

      final item = ScheduleItem(thisStart, duration, type, title, artist, imageUrl: randomUrl());

      newList.add(item);
    });
    return newList;
  } catch (error) {
    debugPrint("parseScheduleFile() => error: $error");
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

DateTime? _createStart(XmlElement element, DateTime start) {
  final eStartDate = element.getElement("START_DATE");
  final eStartTime = element.getElement("START_TIME");

  if (eStartDate == null || eStartTime == null) return start;

  try {
    debugPrint("_createStart() => date = ${eStartDate.innerText}, time = ${eStartTime.innerText}");
    return parseDateTime(eStartDate.innerText, eStartTime.innerText);
  } catch (error) {
    return null;
  }
}

Duration? _createDuration(XmlElement element) {
  final eDuration = element.getElement("DURATION");
  if (eDuration == null) return null;

  try {
    return parseDuration(eDuration.innerText);
  } catch (error) {
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

void logScheduleFile(File file) {
  file.openRead().transform(utf8.decoder).transform(LineSplitter()).forEach((line) => debugPrint(line));
}
