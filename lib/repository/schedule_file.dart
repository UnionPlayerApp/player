import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
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
    final document = XmlDocument.parse(file.readAsStringSync());
    final elements = document.findAllElements("ELEM");
    final newList = List<ScheduleItemRaw>.empty(growable: true);
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

      final item = ScheduleItemRaw(start, duration, type, title, artist, imageUrl: _randomUrl());
      newList.add(item);
    });
    return newList;
  } catch (error) {
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
    return _parseDateTime(eStartDate.innerText, eStartTime.innerText);
  } catch (error) {
    return null;
  }
}

Duration? _createDuration(XmlElement element) {
  final eDuration = element.getElement("DURATION");
  if (eDuration == null) return null;

  try {
    return _parseTime(eDuration.innerText);
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

Duration _parseTime(String time) {
  final parts = time.split(':');
  try {
    final hours = int.parse(parts[2]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[0]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  } catch (error) {
    throw FormatException('Invalid duration element format');
  }
}

DateTime _parseDateTime(String date, String time) {
  try {
    final timeParts = time.split(':');
    final hours = int.parse(timeParts[2]);
    final minutes = int.parse(timeParts[1]);
    final seconds = int.parse(timeParts[0]);

    final dateParts = time.split('-');
    final year = int.parse(dateParts[2]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[0]);

    return DateTime(year, month, day, hours, minutes, seconds);
  } catch (error) {
    throw FormatException('Invalid start date or time format');
  }
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