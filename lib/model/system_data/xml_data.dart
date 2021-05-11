import 'package:cloud_firestore/cloud_firestore.dart';

class XmlData {
  String url = "";

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      url = doc["url"];
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}