import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/date_time.dart';
import 'package:union_player_app/utils/core/debug.dart';
import 'package:union_player_app/utils/core/duration.dart';
import 'package:xml/xml.dart';

List<ScheduleItem> parseScheduleFile(File file) {
  log("parseScheduleFile()", name: LOG_TAG);
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
    log("parseScheduleFile() => error", name: LOG_TAG, error: error);
    throw Exception(error.toString());
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
    log("_createStart() => date = ${eStartDate.innerText}, time = ${eStartTime.innerText}", name: LOG_TAG);
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
  file.openRead().transform(utf8.decoder).transform(LineSplitter()).forEach((line) => log(line, name: LOG_TAG));
}
