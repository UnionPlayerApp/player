import 'package:cloud_firestore/cloud_firestore.dart';

class StreamData {
  String streamHigh = "";
  String streamLow = "";
  String streamMedium = "";

  void setData(DocumentSnapshot<Object?> doc) {
    try {
      streamLow = doc["stream_low"];
      streamMedium = doc["stream_middle"];
      streamHigh = doc["stream_hi"];
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}