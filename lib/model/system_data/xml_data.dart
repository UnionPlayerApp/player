import 'package:cloud_firestore/cloud_firestore.dart';

class XmlData {
  String fileName = "";
  String folder = "";
  String host = "";
  String login = "";
  String password = "";
  String protocol = "";

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      fileName = doc["file_name"];
      folder = doc["folder"];
      host = doc["host"];
      login = doc["login"];
      password = doc["password"];
      protocol = doc["protocol"];
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}