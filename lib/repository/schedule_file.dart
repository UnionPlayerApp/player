import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:union_player_app/model/release_cover/coverartarchive_response.dart';
import 'package:union_player_app/repository/schedule_item.dart';
import 'package:union_player_app/repository/schedule_item_type.dart';
import 'package:union_player_app/utils/constants/constants.dart';
import 'package:union_player_app/utils/core/date_time.dart';
import 'package:union_player_app/utils/core/debug.dart';
import 'package:union_player_app/utils/core/duration.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

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

      final item = ScheduleItem(thisStart, duration, type, title, artist);

      newList.add(item);
    });
    return newList;
  } catch (error) {
    log("parseScheduleFile() => error", name: LOG_TAG, error: error);
    throw Exception(error.toString());
  }
}


Future<List<ScheduleItem>> getScheduleItemRawListWithImages(List<ScheduleItem> _items) async {
  int index = 0;
  await Future.forEach(_items, (ScheduleItem _item) async {
    index++;
    _item.imageUrl = await _getScheduleItemImage(index, _item.type, _item.title, _item.artist);
  });
  return _items;
}

Future<String> _getScheduleItemImage (int index, ScheduleItemType? type, String title, String artist) async {
  String url;
  if (type == ScheduleItemType.music){
     print("Item type is music [index: $index], title: $title, artist: $artist");
     url = await _getCoverUrl(index, title, artist);
     print("_getCoverUrl finished, [index: $index], url: $url");
   } else {
     url = "";
   }
 return url;
}

Future<String> _getCoverUrl(int index, String title, String artist) async {
  String releaseId = await _getReleaseId(index, title, artist);
  if (releaseId != "") {
    print("Release id = $releaseId [index: $index]");
    return await _getReleaseCoverUrl(index, releaseId);
  } else return "";
}

Future<String> _getReleaseId(int index, String title, String artist) async {
  var url = Uri.parse('http://musicbrainz.org/ws/2/recording?query=$title+artist:$artist');
  String? id;
  XmlDocument songsList;
  // Асинхронная операция (Получаем XML список песен, соответвующих запросу поиска по имени трека и исполнителя):
  return http.get(url).then((response) {
    log("Get recording-list response status code: ${response.statusCode}", name: LOG_TAG);
    if(response.statusCode == 200) {
      songsList = XmlDocument.parse(response.body);
      // Берем id первой песни из списка:
      id = songsList.getElement("metadata")
          ?.getElement("recording-list")
          ?.firstElementChild
          ?.getElement("release-list")
          ?.firstElementChild
          ?.getAttribute("id");
      log("Release id: $id, song title: $title, artist: $artist",
          name: LOG_TAG);
    }
    if (id != null) return id!;
    else return "";
  }).catchError((error){
    log("Get release id ERROR [index $index]: ${error.toString()}", name: LOG_TAG);
    return "";
  });
}

Future<String> _getReleaseCoverUrl(int index, String id) async{
  var url = Uri.parse('http://coverartarchive.org/release/$id');
  String? imageUrl;
  // Асинхронная операция (Получаем информацию о релизе по его id в формате JSON, забираем оттуда url миниатюры обложки):
  return http.get(url).then((response){
    log("Get release info response status code [index: $index]: ${response.statusCode}", name: LOG_TAG);
    if(response.statusCode == 200) {
      // Создаем экземпляр модели ответа сервера:
      log("Get release info response body: ${jsonDecode(response.body)}", name: LOG_TAG);
      CoverArtArchiveResponse coverResponse = CoverArtArchiveResponse.fromJson(
          jsonDecode(response.body));
      // Берем url миниатюры размера small:
      imageUrl = coverResponse.images.first.thumbnails?.small;
      log("ReleaseCoverUrl: $imageUrl", name: LOG_TAG);
    }
    if (imageUrl != null) {
      return imageUrl!;
    } else return "";
  }).catchError((error){
    log("Get release cover url ERROR [index $index]: ${error.toString()}; release id: $id", name: LOG_TAG);
    return "";
  });
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
