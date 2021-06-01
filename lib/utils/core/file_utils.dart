import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<File> loadRemoteFile(String url) async {
  try {
    final httpClient = HttpClient();
    final uri = Uri.parse(url);
    final request = await httpClient.getUrl(uri);
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    final path = await _createLocalPath(url);
    return await _createFileFromBytes(path, bytes);
  } catch (error) {
    throw Exception(error.toString());
  }
}

Future<File> loadAssetFile(String assetPath) async {
  try {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    final path = await _createLocalPath(assetPath);
    return await _createFileFromBytes(path, bytes);
  } catch (error) {
    throw Exception(error.toString());
  }
}

Future<String> _createLocalPath(String sourcePath) async {
  try {
    final uri = Uri.parse(sourcePath);
    final dir = (await getApplicationDocumentsDirectory()).path;
    final path = '$dir/${uri.pathSegments.last}';
    return path;
  } catch (error) {
    throw Exception(error.toString());
  }
}

Future<File> _createFileFromBytes(String path, List<int> bytes) async {
  try {
    final file = File(path);
    await file.writeAsBytes(bytes);
    return file;
  } catch (error) {
    throw Exception(error.toString());
  }
}
