import 'package:cloud_firestore/cloud_firestore.dart';

class StreamData {
  String streamHi = "";
  String streamLow = "";
  String streamMiddle = "";

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      streamLow = doc["stream_low"];
      streamMiddle = doc["stream_middle"];
      streamHi = doc["stream_hi"];
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}