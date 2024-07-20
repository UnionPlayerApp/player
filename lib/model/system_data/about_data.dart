import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/constants/constants.dart';

class AboutData {
  var url = "";
  final _dataMap = <String, String>{};

  String get htmlData => _dataMap[_dataKey()] ?? '';

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      url = doc["url"];
      _setDataMap(doc, key: 'data_ru_light');
      _setDataMap(doc, key: 'data_be_light');
      _setDataMap(doc, key: 'data_en_light');
      _setDataMap(doc, key: 'data_ru_dark');
      _setDataMap(doc, key: 'data_be_dark');
      _setDataMap(doc, key: 'data_en_dark');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  String _dataKey() {
    final languageCode = (Get.locale ?? defaultLocale).languageCode.toLowerCase();
    final lightMode = Get.isDarkMode ? "dark" : "light";
    return 'data_${languageCode}_$lightMode';
  }

  void _setDataMap(DocumentSnapshot<Object?> doc, {required String key}) => _dataMap[key] = doc[key];
}