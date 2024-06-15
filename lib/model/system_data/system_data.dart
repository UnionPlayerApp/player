import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:union_player_app/common/enums/string_keys.dart';
import 'package:union_player_app/model/system_data/email_data.dart';
import 'package:union_player_app/model/system_data/player_data.dart';
import 'package:union_player_app/model/system_data/stream_data.dart';
import 'package:union_player_app/model/system_data/xml_data.dart';

import '../../common/constants/constants.dart';
import '../../screen_about_app/developer_model.dart';
import 'about_data.dart';

class SystemData {
  final aboutData = AboutData();
  final emailData = EmailData();
  final streamData = StreamData();
  final xmlData = XmlData();
  final playerData = PlayerData();

  void setAboutData(DocumentSnapshot<Object?> doc) {
    try {
      aboutData.setData(doc);
      debugPrint("AboutData loaded value: ${aboutData.url}");
    } catch (error) {
      debugPrint("AboutData load error: $error");
      throw Exception(error.toString());
    }
  }

  void setEmailData(DocumentSnapshot<Object?> doc) {
    try {
      emailData.setData(doc);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  void setStreamData(DocumentSnapshot<Object?> doc) {
    try {
      streamData.setData(doc);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  void setXmlData(DocumentSnapshot<Object?> doc) {
    try {
      xmlData.setData(doc);
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<List<DeveloperModel>> developers(Locale locale) async {
    return [
      DeveloperModel(
        roleKey: StringKeys.roleDeveloper,
        firstName: _developerFirstName(locale),
        lastName: _developerLastName(locale),
        email: "chplalex.dev@gmail.com",
        whatsapp: "+79037259610",
        telegram: "chepel_alexander",
      ),
      DeveloperModel(
        roleKey: StringKeys.roleDesigner,
        firstName: _designerFirstName(locale),
        lastName: _designerLastName(locale),
        email: "nika.chepel@gmail.com",
        whatsapp: "+79161362221",
        telegram: "nikkache",
      ),
    ];
  }

  static const _mapDeveloperFirstName = {
    languageEN: "Alexander",
    languageRU: "Александр",
    languageBE: "Аляксандер",
  };

  static const _mapDeveloperLastName = {
    languageEN: "Chepel",
    languageRU: "Чепель",
    languageBE: "Чепель",
  };

  static const _mapDesignerFirstName = {
    languageEN: "Nika",
    languageRU: "Ника",
    languageBE: "Нiка",
  };

  static const _mapDesignerLastName = {
    languageEN: "Chepel",
    languageRU: "Чепель",
    languageBE: "Чепель",
  };

  String _developerFirstName(Locale locale) => _mapDeveloperFirstName[locale.languageCode] ?? "";
  String _developerLastName(Locale locale) => _mapDeveloperLastName[locale.languageCode] ?? "";
  String _designerFirstName(Locale locale) => _mapDesignerFirstName[locale.languageCode] ?? "";
  String _designerLastName(Locale locale) => _mapDesignerLastName[locale.languageCode] ?? "";
}
