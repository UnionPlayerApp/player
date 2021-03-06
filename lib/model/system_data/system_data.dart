import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:union_player_app/model/system_data/email_data.dart';
import 'package:union_player_app/model/system_data/player_data.dart';
import 'package:union_player_app/model/system_data/stream_data.dart';
import 'package:union_player_app/model/system_data/xml_data.dart';

import 'about_data.dart';

class SystemData {
  AboutData aboutData = AboutData();
  EmailData emailData = EmailData();
  StreamData streamData = StreamData();
  XmlData xmlData = XmlData();
  PlayerData playerData = PlayerData();

  void setAboutData(DocumentSnapshot<Object?> doc) {
    try {
      aboutData.setData(doc);
    } catch (error) {
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
}