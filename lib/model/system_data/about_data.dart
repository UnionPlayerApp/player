import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:get/get.dart';

import '../../common/constants/constants.dart';
import '../../common/ui/app_colors.dart';
import '../../common/ui/font_sizes.dart';

class AboutData {
  late final _dataMap = <String, String>{};

  late final _darkStyles = {
    "body": html.Style(
      color: AppColors.cultured,
      backgroundColor: AppColors.transparent,
      fontFamily: 'Open Sans',
      fontSize: html.FontSize(FontSizes.px14),
    ),
  };

  late final _lightStyles = {
    "body": html.Style(
      color: AppColors.blackOlive,
      backgroundColor: AppColors.transparent,
      fontFamily: 'Open Sans',
      fontSize: html.FontSize(FontSizes.px14),
    ),
  };

  String get htmlData => _dataMap[_dataKey()] ?? '';

  Map<String, html.Style> get htmlStyles => Get.isDarkMode ? _darkStyles : _lightStyles;

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      _setDataMap(doc, key: 'data_ru');
      _setDataMap(doc, key: 'data_be');
      _setDataMap(doc, key: 'data_en');
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  String _dataKey() {
    final languageCode = (Get.locale ?? defaultLocale).languageCode.toLowerCase();
    return 'data_$languageCode';
  }

  void _setDataMap(DocumentSnapshot<Object?> doc, {required String key}) => _dataMap[key] = doc[key];
}