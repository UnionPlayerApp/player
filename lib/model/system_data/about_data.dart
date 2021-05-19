import 'package:cloud_firestore/cloud_firestore.dart';

class AboutData {
  String urlBy = "";
  String urlEn = "";
  String urlRu = "";

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      urlBy = doc["url_by"];
      urlEn = doc["url_en"];
      urlRu = doc["url_ru"];
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}