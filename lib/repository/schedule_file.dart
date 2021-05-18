import 'dart:convert';
import 'dart:developer' as Log;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/date_time.dart';
import 'package:union_player_app/utils/core/duration.dart';
import 'package:xml/xml.dart';

Future<File> loadScheduleFile(String url) async {
  try {
    final httpClient = HttpClient();
    final uri = Uri.parse(url);
    final request = await httpClient.getUrl(uri);
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final dir = (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir/${uri.pathSegments.last}');
    await file.writeAsBytes(bytes);
    return file;
  } catch (error) {
    throw Exception(error.toString());
  }
}

List<ScheduleItemRaw> parseScheduleFile(File file) {
  try {
    Log.log("XmlDocument.parse() - in", name: LOG_TAG);
    final document = XmlDocument.parse(file.readAsStringSync());
    Log.log("XmlDocument.parse() - out", name: LOG_TAG);

    Log.log("document.findAllElements() - in", name: LOG_TAG);
    final elements = document.findAllElements("ELEM");
    Log.log("document.findAllElements() - out", name: LOG_TAG);

    final newList = List<ScheduleItemRaw>.empty(growable: true);
    DateTime start = DateTime.now();

    int index = 0;

    elements.forEach((element) {
      index++;
      Log.log("elements.forEach() => index = $index", name: LOG_TAG);

      final type = _createType(element);
      if (type == null) return;

      final duration = _createDuration(element);
      if (duration == null) return;

      final thisStart = _createStart(element, start);
      if (thisStart == null) return;
      start = thisStart.add(duration);

      final title = _createTitle(element);
      final artist = _createArtist(element);

      final item = ScheduleItemRaw(thisStart, duration, type, title, artist,
          imageUrl: _randomUrl());
      newList.add(item);
      Log.log("type = $type, start = $thisStart, duration = $duration, title = $title, artist = $artist", name: LOG_TAG);
    });
    return newList;
  } catch (error) {
    Log.log("parseScheduleFile() => error", name: LOG_TAG, error: error);
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
    Log.log("_createStart() => date = ${eStartDate.innerText}, time = ${eStartTime.innerText}", name: LOG_TAG);
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

String _randomUrl() {
  List<String> urls = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRygBKRZC_XhwMXnmXT-Wq_8TGT4MSkV3KY-A&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsh0I61KOzNAOzvjEmMUKjmH9EZwxB2UGovg&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhUkOp_uSZY5R2gsHMxKt6nTIy-isvdm7pxQ&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRWS-O75WhJE-wnol-9NfBr54rmbsUc0LeDA&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoydUqpTZ-TQ2h-IDrwIwuQjtWd44w2IXPWQ&usqp=CAU"
  ];
  final index = Random().nextInt(urls.length - 1);
  return urls[index];
}

void logScheduleFile(File file) {
  file
      .openRead()
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) => Log.log(line, name: LOG_TAG));
}
