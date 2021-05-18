import 'package:cloud_firestore/cloud_firestore.dart';

class AboutData {
  String textBy = "";
  String textEn = "";
  String textRu = "";
  String urlBy = "";
  String urlEn = "";
  String urlRu = "";

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      textBy = doc["text_by"];
      textEn = doc["text_en"];
      textRu = doc["text_ru"];
      urlBy = doc["url_by"];
      urlEn = doc["url_en"];
      urlRu = doc["url_ru"];
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}