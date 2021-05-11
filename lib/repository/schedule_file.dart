import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:union_player_app/repository/schedule_item_raw.dart';
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
    return document.children
        .map((XmlNode node) => ScheduleItemRaw(_createStart(node),
            _createDuration(node), _createTitle(node), _createArtist(node)))
        .toList(growable: false);
  } catch (error) {
    throw Exception(error.toString());
  }
}

DateTime _createStart(XmlNode node) {
  return DateTime.now();
}

Duration _createDuration(XmlNode node) {
  return Duration();
}

String _createArtist(XmlNode node) {
  return node.findElements("ARTIST").first.text;
}

String _createTitle(XmlNode node) {
  return node.findElements("TITLE").first.text;
}